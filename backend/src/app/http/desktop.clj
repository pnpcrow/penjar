;; This Source Code Form is subject to the terms of the Mozilla Public
;; License, v. 2.0. If a copy of the MPL was not distributed with this
;; file, You can obtain one at http://mozilla.org/MPL/2.0/.
;;
;; Copyright (c) KALEIDOS INC

(ns app.http.desktop
  "Desktop-oriented HTTP endpoints that expose auth/session flows in a
  transport shape that the Flutter desktop runtime can consume directly."
  (:require
   [app.common.data :as d]
   [app.common.exceptions :as ex]
   [app.common.json :as json]
   [app.common.schema :as sm]
   [app.common.time :as ct]
   [app.common.transit :as t]
   [app.db :as db]
   [app.http :as-alias http]
   [app.http.session :as session]
   [app.rpc :as-alias rpc]
   [app.rpc.commands.auth :as cmd.auth]
   [app.rpc.commands.files :as cmd.files]
   [app.rpc.commands.files-create :as cmd.files-create]
   [app.rpc.commands.profile :as cmd.profile]
   [app.rpc.commands.projects :as cmd.projects]
   [app.rpc.helpers :as rph]
   [integrant.core :as ig]
   [yetti.request :as yreq]
   [yetti.response :as-alias yres])
  (:import
   java.io.InputStream))

(declare ^:private refresh-token)
(declare ^:private create-file)
(declare ^:private create-project)
(declare ^:private delete-first-file)
(declare ^:private project-name-by-id)
(declare ^:private project-state-payload)
(declare ^:private projects-state-response)
(declare ^:private select-project)
(declare ^:private restore-session)
(declare ^:private set-session-preferences)
(declare ^:private sign-in)

(defmethod ig/assert-key ::routes
  [_ params]
  (assert (db/pool? (::db/pool params)) "expect valid database pool")
  (assert
   (session/manager? (::session/manager params))
   "expect valid session manager"))

(def ^:private default-system
  {:name ::default-system
   :compile
   (fn [_ _]
     (fn [handler cfg]
       (fn [request]
         (handler cfg request))))})

(defn- coercer
  [schema & {:as opts}]
  (let [decode-fn (sm/decoder schema sm/json-transformer)
        check-fn  (sm/check-fn schema opts)]
    (fn [data]
      (-> data decode-fn check-fn))))

(def ^:private schema:sign-in
  cmd.auth/schema:login-with-password)

(def ^:private coerce-sign-in-params
  (coercer schema:sign-in
           :type :validation
           :hint "invalid desktop auth sign-in payload"))

(def ^:private schema:session-preferences
  [:map {:title "desktop-session-preferences"}
   [:remember-session {:optional true} :boolean]
   [:remember-session-enabled {:optional true} :boolean]])

(def ^:private coerce-session-preferences
  (coercer schema:session-preferences
           :type :validation
           :hint "invalid desktop auth session preferences payload"))

(def ^:private schema:create-project
  [:map {:title "desktop-create-project"}
   [:project-name {:optional true} [:string {:max 250}]]
   [:name {:optional true} [:string {:max 250}]]])

(def ^:private coerce-create-project-params
  (coercer schema:create-project
           :type :validation
           :hint "invalid desktop project create payload"))

(def ^:private schema:select-project
  [:map {:title "desktop-select-project"}
   [:index :int]])

(def ^:private coerce-select-project-params
  (coercer schema:select-project
           :type :validation
           :hint "invalid desktop project selection payload"))

(def ^:private schema:create-file
  [:map {:title "desktop-create-file"}
   [:selected-project-id ::sm/uuid]
   [:file-name {:optional true} [:string {:max 250}]]
   [:name {:optional true} [:string {:max 250}]]])

(def ^:private coerce-create-file-params
  (coercer schema:create-file
           :type :validation
           :hint "invalid desktop file create payload"))

(def ^:private schema:delete-first-file
  [:map {:title "desktop-delete-first-file"}
   [:selected-project-id ::sm/uuid]])

(def ^:private coerce-delete-first-file-params
  (coercer schema:delete-first-file
           :type :validation
           :hint "invalid desktop file delete payload"))

(defmethod ig/init-key ::routes
  [_ cfg]
  ["/desktop" {:middleware [[session/authz cfg]
                            [default-system cfg]]}
   ["/auth/sign-in"
    {:handler sign-in
     :allowed-methods #{:post}}]
   ["/auth/session/preferences"
    {:handler set-session-preferences
     :allowed-methods #{:patch :post}}]
   ["/auth/session/restore"
    {:handler restore-session
     :allowed-methods #{:post}}]
   ["/auth/token/refresh"
    {:handler refresh-token
     :allowed-methods #{:post}}]
   ["/projects"
    {:handler create-project
     :allowed-methods #{:post}}]
   ["/projects/select"
    {:handler select-project
     :allowed-methods #{:post}}]
   ["/projects/files"
    {:handler create-file
     :allowed-methods #{:post}}]
   ["/projects/files/first"
    {:handler delete-first-file
     :allowed-methods #{:delete :post}}]])

(defn- read-transit-body
  [^InputStream body]
  (with-open [is body]
    (t/read! (t/reader is))))

(defn- read-json-body
  [^InputStream body]
  (with-open [reader (java.io.BufferedReader.
                      (java.io.InputStreamReader. body))]
    (json/read reader :key-fn json/read-kebab-key)))

(defn- parse-body-params
  [request]
  (let [content-type (or (yreq/get-header request "content-type") "")
        body         (yreq/body request)]
    (cond
      (nil? body)
      {}

      (.startsWith content-type "application/transit+json")
      (or (read-transit-body body) {})

      (.startsWith content-type "application/json")
      (or (read-json-body body) {})

      :else
      {})))

(defn- request-params
  [request]
  (if (contains? request :body-params)
    (:params request)
    (merge (:params request) (parse-body-params request))))

(defn- run-response-transforms
  [request response mdata]
  (reduce (fn [response transform-fn]
            (transform-fn request response))
          response
          (::rpc/response-transform-fns mdata)))

(defn- run-before-complete-hooks
  [mdata response]
  (doseq [hook-fn (::rpc/before-complete-fns mdata)]
    (ex/ignoring (hook-fn)))
  response)

(defn- rpc-response
  [request result body]
  (let [mdata    (meta result)
        headers  (::http/headers mdata {})
        response {::yres/status  (or (::http/status mdata) 200)
                  ::yres/headers headers
                  ::yres/body    body}
        response (run-response-transforms request response mdata)]
    (run-before-complete-hooks mdata response)))

(defn- current-profile
  [cfg request]
  (some-> (::session/profile-id request)
          (cmd.profile/get-profile cfg)
          (cmd.profile/strip-private-attrs)))

(defn- desktop-auth-body
  [{:keys [status code message state result]}]
  (d/without-nils
   {:status status
    :code code
    :message message
    :state state
    :result result}))

(defn- signed-out-response
  [{:keys [status code message remember-session]}]
  {::yres/status 401
   ::yres/body   (desktop-auth-body
                  {:status status
                   :code code
                   :message message
                   :state (d/without-nils
                           {:signed-in false
                            :signed-out true
                            :remember-session remember-session})})})

(defn- success-auth-response
  [request result {:keys [status remember-session profile payload]}]
  (rpc-response
   request
   result
   (desktop-auth-body
    {:status status
     :result payload
     :state (d/without-nils
             {:signed-in true
              :remember-session remember-session
              :profile profile})})))

(defn- project-name-by-id
  [cfg profile project-id]
  (some->> (cmd.projects/get-projects cfg (:id profile) (:default-team-id profile))
           (remove :deleted-at)
           (some (fn [project]
                   (when (= project-id (:id project))
                     (:name project))))))

(defn- project-state-payload
  [cfg {:keys [profile-id team-id selected-project-id selected-index]}]
  (let [projects (->> (cmd.projects/get-projects cfg profile-id team-id)
                      (remove :deleted-at)
                      (mapv
                       (fn [project]
                         {:id (:id project)
                          :name (:name project)
                          :files (->> (cmd.files/get-project-files cfg (:id project))
                                      (mapv :name))})))
        fallback-selected-index
        (if (seq projects)
          (or (some->> selected-project-id
                       (keep-indexed
                        (fn [index project]
                          (when (= selected-project-id (:id project))
                            index)))
                       first)
              0)
          0)
        resolved-selected-index
        (cond
          (empty? projects) 0
          (nil? selected-index) fallback-selected-index
          (< selected-index 0) 0
          (>= selected-index (count projects)) (dec (count projects))
          :else selected-index)]
    {:projects projects
     :selected-project-index resolved-selected-index}))

(defn- projects-state-response
  [cfg request {:keys [status selected-project-id selected-index]}]
  (if-let [profile (current-profile cfg request)]
    (let [{:keys [default-team-id default-project-id]} profile
          {:keys [projects selected-project-index]}
          (project-state-payload
           cfg
           {:profile-id (:id profile)
            :team-id default-team-id
            :selected-project-id (or selected-project-id default-project-id)
            :selected-index selected-index})]
      {::yres/status 200
       ::yres/body   {:status status
                      :state {:projects projects
                              :selected-project-index selected-project-index}}})
    (signed-out-response
     {:status "Authentication required."
      :code "AUTHENTICATION_REQUIRED"
      :message "Authentication required."})))

(defn- sign-in
  [cfg request]
  (let [params  (-> request request-params coerce-sign-in-params)
        result  (cmd.auth/login-with-password cfg params)
        payload (rph/unwrap result)
        profile (some-> (get payload :id)
                        (cmd.profile/get-profile cfg)
                        (cmd.profile/strip-private-attrs))]
    (success-auth-response
     request
     result
     {:status "Signed in."
      :profile profile
      :payload payload})))

(defn- set-session-preferences
  [cfg request]
  (let [params            (-> request request-params coerce-session-preferences)
        remember-session  (or (:remember-session params)
                              (:remember-session-enabled params)
                              false)
        profile           (current-profile cfg request)
        signed-in?        (some? profile)]
    {::yres/status 200
     ::yres/body   (desktop-auth-body
                    {:status (if remember-session
                               "Remember session enabled."
                               "Remember session disabled.")
                     :state (d/without-nils
                             {:signed-in signed-in?
                              :remember-session remember-session
                              :profile profile})})}))

(defn- restore-session
  [cfg request]
  (let [params           (request-params request)
        remember-session (:remember-session-enabled params)]
    (if-let [profile (current-profile cfg request)]
      {::yres/status 200
       ::yres/body   (desktop-auth-body
                      {:status "Session restored."
                       :state (d/without-nils
                               {:signed-in true
                                :remember-session remember-session
                                :profile profile})})}
      (signed-out-response
       {:status "Authentication required."
        :code "AUTHENTICATION_REQUIRED"
        :message "Authentication required."
        :remember-session remember-session}))))

(defn- refresh-token
  [cfg request]
  (if-let [profile (current-profile cfg request)]
    {::yres/status 200
     ::yres/body   (desktop-auth-body
                    {:status "Token refreshed."
                     :state {:signed-in true
                             :profile profile}})}
    (signed-out-response
     {:status "Backend session expired."
      :code "SESSION_TIMEOUT"
      :message "Backend session expired."})))

(defn- create-project
  [cfg request]
  (if-let [profile (current-profile cfg request)]
    (let [params       (-> request request-params coerce-create-project-params)
          project-name (or (:project-name params) (:name params) "")
          normalized   (.trim ^String project-name)]
      (if (.isEmpty normalized)
        (projects-state-response
         cfg
         request
         {:status "Project create failed: project name is required."})
        (let [project (db/tx-run!
                       cfg
                       #'cmd.projects/create-project
                       {::rpc/profile-id (:id profile)
                        ::rpc/request-at (ct/now)
                        :profile-id (:id profile)
                        :team-id (:default-team-id profile)
                        :name normalized})]
          (projects-state-response
           cfg
           request
           {:status (str "Project created: " normalized ".")
            :selected-project-id (:id project)}))))
    (signed-out-response
     {:status "Authentication required."
      :code "AUTHENTICATION_REQUIRED"
      :message "Authentication required."})))

(defn- select-project
  [cfg request]
  (if-let [profile (current-profile cfg request)]
    (let [params            (-> request request-params coerce-select-project-params)
          index             (:index params)
          {:keys [projects]} (project-state-payload
                              cfg
                              {:profile-id (:id profile)
                               :team-id (:default-team-id profile)
                               :selected-project-id (:default-project-id profile)})]
      (if (or (< index 0) (>= index (count projects)))
        (projects-state-response
         cfg
         request
         {:status "Project switch failed: invalid project index."})
        (projects-state-response
         cfg
         request
         {:status (str "Project selected: " (:name (nth projects index)) ".")
          :selected-index index})))
    (signed-out-response
     {:status "Authentication required."
      :code "AUTHENTICATION_REQUIRED"
      :message "Authentication required."})))

(defn- create-file
  [cfg request]
  (if-let [profile (current-profile cfg request)]
    (let [params        (-> request request-params coerce-create-file-params)
          file-name     (or (:file-name params) (:name params) "")
          normalized    (.trim ^String file-name)
          project-id    (:selected-project-id params)
          project-name  (or (project-name-by-id cfg profile project-id)
                            "project")]
      (if (.isEmpty normalized)
        (projects-state-response
         cfg
         request
         {:status "File create failed: file name is required."
          :selected-project-id project-id})
        (do
          (db/tx-run!
           cfg
           cmd.files-create/create-file
           {::rpc/profile-id (:id profile)
            :profile-id (:id profile)
            :project-id project-id
            :name normalized})
          (projects-state-response
           cfg
           request
           {:status (str "File created in " project-name ": " normalized ".")
            :selected-project-id project-id}))))
    (signed-out-response
     {:status "Authentication required."
      :code "AUTHENTICATION_REQUIRED"
      :message "Authentication required."})))

(defn- delete-first-file
  [cfg request]
  (if-let [profile (current-profile cfg request)]
    (let [params       (-> request request-params coerce-delete-first-file-params)
          project-id   (:selected-project-id params)
          project-name (or (project-name-by-id cfg profile project-id)
                           "project")
          first-file   (some->> (cmd.files/get-project-files cfg project-id)
                                first)
          file-id      (:id first-file)
          file-name    (:name first-file)]
      (if (nil? file-id)
        (projects-state-response
         cfg
         request
         {:status "File delete skipped: no file exists."
          :selected-project-id project-id})
        (do
          (db/tx-run!
           cfg
           #'cmd.files/delete-file
           {:profile-id (:id profile)
            :id file-id})
          (projects-state-response
           cfg
           request
           {:status (str "File deleted from " project-name ": " file-name ".")
            :selected-project-id project-id}))))
    (signed-out-response
     {:status "Authentication required."
      :code "AUTHENTICATION_REQUIRED"
      :message "Authentication required."})))
