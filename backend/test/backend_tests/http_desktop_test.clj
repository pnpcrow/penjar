;; This Source Code Form is subject to the terms of the Mozilla Public
;; License, v. 2.0. If a copy of the MPL was not distributed with this
;; file, You can obtain one at http://mozilla.org/MPL/2.0/.
;;
;; Copyright (c) KALEIDOS INC

(ns backend-tests.http-desktop-test
  (:require
   [app.config :as cf]
   [app.http.desktop :as desktop]
   [app.http.session :as session]
   [backend-tests.helpers :as th]
   [clojure.test :as t]
   [yetti.response :as-alias yres]))

(t/use-fixtures :once th/state-init)
(t/use-fixtures :each th/database-reset)

(t/deftest desktop-sign-in-applies-auth-state-and-session-cookie
  (let [profile  (th/create-profile* 1 {:is-active true})
        request  {:params {:email (:email profile)
                           :password "123123"}}
        response (#'desktop/sign-in th/*system* request)
        body     (::yres/body response)
        cookies  (::yres/cookies response)
        cname    (cf/get :auth-token-cookie-name)]
    (t/is (= 200 (::yres/status response)))
    (t/is (true? (-> body :state :signed-in)))
    (t/is (= (:email profile) (-> body :state :profile :email)))
    (t/is (string? (get-in cookies [cname :value])))))

(t/deftest desktop-restore-session-returns-profile-when-session-is-present
  (let [profile  (th/create-profile* 1 {:is-active true})
        request  {::session/profile-id (:id profile)
                  :params {}}
        response (#'desktop/restore-session th/*system* request)
        body     (::yres/body response)]
    (t/is (= 200 (::yres/status response)))
    (t/is (true? (-> body :state :signed-in)))
    (t/is (= (:email profile) (-> body :state :profile :email)))
    (t/is (= "Session restored." (:status body)))))

(t/deftest desktop-restore-session-returns-signed-out-payload-without-session
  (let [response (#'desktop/restore-session
                  th/*system*
                  {:params {:remember-session-enabled true}})
        body     (::yres/body response)]
    (t/is (= 401 (::yres/status response)))
    (t/is (= "AUTHENTICATION_REQUIRED" (:code body)))
    (t/is (false? (-> body :state :signed-in)))
    (t/is (true? (-> body :state :signed-out)))
    (t/is (true? (-> body :state :remember-session)))))

(t/deftest desktop-refresh-token-returns-session-expired-payload-without-session
  (let [response (#'desktop/refresh-token th/*system* {:params {}})
        body     (::yres/body response)]
    (t/is (= 401 (::yres/status response)))
    (t/is (= "SESSION_TIMEOUT" (:code body)))
    (t/is (= "Backend session expired." (:status body)))
    (t/is (true? (-> body :state :signed-out)))))

(t/deftest desktop-session-preferences-echo-remember-session-state
  (let [profile  (th/create-profile* 1 {:is-active true})
        response (#'desktop/set-session-preferences
                  th/*system*
                  {::session/profile-id (:id profile)
                   :params {:remember-session true}})
        body     (::yres/body response)]
    (t/is (= 200 (::yres/status response)))
    (t/is (true? (-> body :state :signed-in)))
    (t/is (true? (-> body :state :remember-session)))
    (t/is (= (:email profile) (-> body :state :profile :email)))))

(t/deftest desktop-create-project-returns-updated-project-state
  (let [profile  (th/create-profile* 1 {:is-active true})
        response (#'desktop/create-project
                  th/*system*
                  {::session/profile-id (:id profile)
                   :params {:project-name "Desktop Project"}})
        body     (::yres/body response)
        projects (-> body :state :projects)
        selected (nth projects (-> body :state :selected-project-index))]
    (t/is (= 200 (::yres/status response)))
    (t/is (= "Project created: Desktop Project." (:status body)))
    (t/is (some #(= "Desktop Project" (:name %)) projects))
    (t/is (= "Desktop Project" (:name selected)))
    (t/is (= [] (:files selected)))))

(t/deftest desktop-select-project-returns-selected-index
  (let [profile (th/create-profile* 1 {:is-active true})]
    (#'desktop/create-project
     th/*system*
     {::session/profile-id (:id profile)
      :params {:project-name "Desktop Project A"}})
    (#'desktop/create-project
     th/*system*
     {::session/profile-id (:id profile)
      :params {:project-name "Desktop Project B"}})
    (let [response (#'desktop/select-project
                    th/*system*
                    {::session/profile-id (:id profile)
                     :params {:index 1}})
          body     (::yres/body response)]
      (t/is (= 200 (::yres/status response)))
      (t/is (= 1 (-> body :state :selected-project-index)))
      (t/is (= "Project selected: Desktop Project A." (:status body))))))

(t/deftest desktop-file-lifecycle-updates-project-state
  (let [profile         (th/create-profile* 1 {:is-active true})
        create-project  (#'desktop/create-project
                         th/*system*
                         {::session/profile-id (:id profile)
                          :params {:project-name "Desktop Files"}})
        create-project-body (::yres/body create-project)
        created-project (nth
                         (-> create-project-body :state :projects)
                         (-> create-project-body :state :selected-project-index))
        selected-project (:id created-project)
        create-response (#'desktop/create-file
                         th/*system*
                         {::session/profile-id (:id profile)
                          :params {:selected-project-id selected-project
                                   :file-name "desktop-file.penjar"}})
        create-body     (::yres/body create-response)
        delete-response (#'desktop/delete-first-file
                         th/*system*
                         {::session/profile-id (:id profile)
                          :params {:selected-project-id selected-project}})
        delete-body     (::yres/body delete-response)]
    (t/is (= 200 (::yres/status create-response)))
    (t/is (= "File created in Desktop Files: desktop-file.penjar." (:status create-body)))
    (t/is (some #(some #{"desktop-file.penjar"} (:files %))
                (-> create-body :state :projects)))
    (t/is (= 200 (::yres/status delete-response)))
    (t/is (= "File deleted from Desktop Files: desktop-file.penjar."
             (:status delete-body)))))
