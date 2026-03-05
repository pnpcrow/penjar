;; This Source Code Form is subject to the terms of the Mozilla Public
;; License, v. 2.0. If a copy of the MPL was not distributed with this
;; file, You can obtain one at http://mozilla.org/MPL/2.0/.
;;
;; Copyright (c) KALEIDOS INC

(ns app.main.ui.shapes.export
  "Components that generates penjar specific svg nodes with
  exportation data. This xml nodes serves mainly to enable
  importation."
  (:require
   [app.common.data :as d]
   [app.common.data.macros :as dm]
   [app.common.geom.shapes :as gsh]
   [app.common.json :as json]
   [app.common.svg :as csvg]
   [app.main.ui.context :as muc]
   [app.util.object :as obj]
   [cuerdas.core :as str]
   [rumext.v2 :as mf]))

(def ^:private internal-counter (atom 0))

(def include-metadata-ctx
  (mf/create-context false))

(mf/defc render-xml
  [{{:keys [tag attrs content] :as node} :xml}]

  (cond
    (map? node)
    (let [props (-> (csvg/attrs->props attrs)
                    (json/->js :key-fn name))]
      [:> (d/name tag) props
       (for [child content]
         [:& render-xml {:xml child :key (swap! internal-counter inc)}])])

    (string? node)
    node

    :else
    nil))

(defn bool->str [val]
  (when (some? val) (str val)))

(defn touched->str [val]
  (str/join " " (map str val)))

(defn add-factory [shape]
  (fn add!
    ([props attr]
     (add! props attr str))

    ([props attr trfn]
     (let [val (get shape attr)
           val (if (keyword? val) (d/name val) val)
           ns-attr (-> (str "penjar:" (-> attr d/name))
                       (str/strip-suffix "?"))]
       (cond-> props
         (some? val)
         (obj/set! ns-attr (trfn val)))))))

(defn add-data
  "Adds as metadata properties that we cannot deduce from the exported SVG"
  [props shape]
  (let [add! (add-factory shape)
        frame? (= :frame (:type shape))
        group? (= :group (:type shape))
        rect?  (= :rect (:type shape))
        image? (= :image (:type shape))
        text?  (= :text (:type shape))
        path?  (= :path (:type shape))
        mask?  (and group? (:masked-group shape))
        bool?  (= :bool (:type shape))
        center (gsh/shape->center shape)]
    (-> props
        (add! :name)
        (add! :blocked)
        (add! :hidden)
        (add! :type)
        (add! :stroke-style)
        (add! :stroke-alignment)
        (add! :hide-fill-on-export)
        (add! :transform)
        (add! :transform-inverse)
        (add! :flip-x)
        (add! :flip-y)
        (add! :proportion)
        (add! :proportion-lock)
        (add! :rotation)
        (obj/set! "penjar:center-x" (-> center :x str))
        (obj/set! "penjar:center-y" (-> center :y str))

        ;; Constraints
        (add! :constraints-h)
        (add! :constraints-v)
        (add! :fixed-scroll)

        (cond-> frame?
          (-> (add! :show-content)
              (add! :hide-in-viewer)))

        (cond-> (and frame? (:use-for-thumbnail shape))
          (add! :use-for-thumbnail))

        (cond-> (and (or rect? image? frame?) (some? (:r1 shape)))
          (-> (add! :r1)
              (add! :r2)
              (add! :r3)
              (add! :r4)))

        (cond-> path?
          (-> (add! :stroke-cap-start)
              (add! :stroke-cap-end)))

        (cond-> text?
          (-> (add! :x)
              (add! :y)
              (add! :width)
              (add! :height)
              (add! :grow-type)
              (add! :content json/encode)
              (add! :position-data json/encode)))

        (cond-> mask?
          (obj/set! "penjar:masked-group" "true"))

        (cond-> bool?
          (add! :bool-type)))))

(defn add-library-refs [props shape]
  (let [add! (add-factory shape)]
    (-> props
        (add! :fill-color-ref-id)
        (add! :fill-color-ref-file)
        (add! :stroke-color-ref-id)
        (add! :stroke-color-ref-file)
        (add! :typography-ref-id)
        (add! :typography-ref-file)
        (add! :component-file)
        (add! :component-id)
        (add! :component-root)
        (add! :main-instance)
        (add! :shape-ref)
        (add! :touched touched->str))))

(defn prefix-keys [m]
  (letfn [(prefix-entry [[k v]]
            [(str "penjar:" (d/name k)) v])]
    (into {} (map prefix-entry) m)))

(defn- export-grid-data [{:keys [grids]}]
  (when (d/not-empty? grids)
    (mf/html
     [:> "penjar:grids" #js {}
      (for [{:keys [type display params]} grids]
        (let [props (->> (dissoc params :color)
                         (prefix-keys)
                         (clj->js))]
          [:> "penjar:grid"
           (-> props
               (obj/set! "penjar:color" (get-in params [:color :color]))
               (obj/set! "penjar:opacity" (get-in params [:color :opacity]))
               (obj/set! "penjar:type" (d/name type))
               (cond-> (some? display)
                 (obj/set! "penjar:display" (str display))))]))])))

(mf/defc export-flows
  [{:keys [flows]}]
  [:> "penjar:flows" #js {}
   (for [{:keys [id name starting-frame]} (vals flows)]
     [:> "penjar:flow" #js {:id id
                            :key id
                            :name name
                            :starting-frame starting-frame}])])

(mf/defc export-guides
  [{:keys [guides]}]
  [:> "penjar:guides" #js {}
   (for [{:keys [position frame-id axis]} (vals guides)]
     [:> "penjar:guide" #js {:position position
                             :frame-id frame-id
                             :axis (d/name axis)}])])

(mf/defc export-page
  {::mf/props :obj}
  [{:keys [page]}]
  (let [id     (get page :id)
        grids  (get page :grids)
        flows  (get page :flows)
        guides (get page :guides)]
    [:> "penjar:page" #js {:id id}
     (when (d/not-empty? grids)
       (let [parse-grid (fn [[type params]] {:type type :params params})
             grids (mapv parse-grid grids)]
         [:& export-grid-data {:grids grids}]))

     (when (d/not-empty? flows)
       [:& export-flows {:flows flows}])

     (when (d/not-empty? guides)
       [:& export-guides {:guides guides}])]))

(defn- export-shadow-data [{:keys [shadow]}]
  (mf/html
   (for [{:keys [style hidden color offset-x offset-y blur spread]} shadow]
     [:> "penjar:shadow"
      #js {:penjar:shadow-type (d/name style)
           :key (swap! internal-counter inc)
           :penjar:hidden (str hidden)
           :penjar:color (str (:color color))
           :penjar:opacity (str (:opacity color))
           :penjar:offset-x (str offset-x)
           :penjar:offset-y (str offset-y)
           :penjar:blur (str blur)
           :penjar:spread (str spread)}])))

(defn- export-blur-data [{:keys [blur]}]
  (when-let [{:keys [type hidden value]} blur]
    (mf/html
     [:> "penjar:blur"
      #js {:penjar:blur-type (d/name type)
           :penjar:hidden    (str hidden)
           :penjar:value     (str value)}])))

(defn export-exports-data [{:keys [exports]}]
  (mf/html
   (for [{:keys [scale suffix type]} exports]
     [:> "penjar:export"
      #js {:penjar:type   (d/name type)
           :key (swap! internal-counter inc)
           :penjar:suffix suffix
           :penjar:scale  (str scale)}])))

(defn str->style
  [style-str]
  (if (string? style-str)
    (->> (str/split style-str ";")
         (map str/trim)
         (map #(str/split % ":"))
         (group-by first)
         (map (fn [[key val]]
                (vector (keyword key) (second (first val)))))
         (into {}))
    style-str))

(defn style->str
  [style]
  (->> style
       (map (fn [[key val]] (str (d/name key) ":" val)))
       (str/join "; ")))

(defn- export-svg-data [shape]
  (mf/html
   [:*
    (when (contains? shape :svg-attrs)
      (let [svg-transform (get shape :svg-transform)
            svg-attrs     (->> shape :svg-attrs keys (mapv (comp d/name str/kebab)) (str/join ","))
            svg-defs      (->> shape :svg-defs keys (mapv d/name) (str/join ","))]
        [:> "penjar:svg-import"
         #js {:penjar:svg-attrs          (when-not (empty? svg-attrs) svg-attrs)
              ;; Style and filter are special properties so we need to save it otherwise will be indistingishible from
              ;; standard properties
              :penjar:svg-style          (when (contains? (:svg-attrs shape) :style) (style->str (get-in shape [:svg-attrs :style])))
              :penjar:svg-filter         (when (contains? (:svg-attrs shape) :filter) (get-in shape [:svg-attrs :filter]))
              :penjar:svg-defs           (when-not (empty? svg-defs) svg-defs)
              :penjar:svg-transform      (when svg-transform (str svg-transform))
              :penjar:svg-viewbox-x      (get-in shape [:svg-viewbox :x])
              :penjar:svg-viewbox-y      (get-in shape [:svg-viewbox :y])
              :penjar:svg-viewbox-width  (get-in shape [:svg-viewbox :width])
              :penjar:svg-viewbox-height (get-in shape [:svg-viewbox :height])}
         (for [[def-id def-xml] (:svg-defs shape)]
           [:> "penjar:svg-def" #js {:def-id def-id
                                     :key (swap! internal-counter inc)}
            [:& render-xml {:xml def-xml}]])]))

    (when (= (:type shape) :svg-raw)
      (let [shape (-> shape (d/update-in-when [:content :attrs :style] str->style))
            props
            (-> (obj/create)
                (obj/set! "penjar:x" (:x shape))
                (obj/set! "penjar:y" (:y shape))
                (obj/set! "penjar:width" (:width shape))
                (obj/set! "penjar:height" (:height shape))
                (obj/set! "penjar:tag" (-> (get-in shape [:content :tag]) d/name))
                (obj/merge! (-> (get-in shape [:content :attrs])
                                (clj->js))))]
        [:> "penjar:svg-content" props
         (for [leaf (->> shape :content :content (filter string?))]
           [:> "penjar:svg-child" {:key (swap! internal-counter inc)} leaf])]))]))


(defn- export-fills-data [{:keys [fills]}]
  (when-let [fills     (seq fills)]
    (let [render-id (mf/use-ctx muc/render-id)]
      (mf/html
       [:> "penjar:fills" #js {}
        (for [[index fill] (d/enumerate fills)]
          (let [fill-image-id (dm/str "fill-image-" render-id "-" index)]
            [:> "penjar:fill"
             #js {:penjar:fill-color          (cond
                                                (some? (:fill-color-gradient fill))
                                                (str/format "url(#%s)" (str "fill-color-gradient-" render-id "-" index))

                                                :else
                                                (d/name (:fill-color fill)))
                  :key                        (swap! internal-counter inc)

                  :penjar:fill-image-id       (when (:fill-image fill) fill-image-id)
                  :penjar:fill-color-ref-file (d/name (:fill-color-ref-file fill))
                  :penjar:fill-color-ref-id   (d/name (:fill-color-ref-id fill))
                  :penjar:fill-opacity        (d/name (:fill-opacity fill))}]))]))))

(defn- export-strokes-data [{:keys [strokes]}]
  (when-let [strokes (seq strokes)]
    (let [render-id (mf/use-ctx muc/render-id)]
      (mf/html
       [:> "penjar:strokes" #js {}
        (for [[index stroke] (d/enumerate strokes)]
          (let [stroke-image-id (dm/str "stroke-image-" render-id "-" index)]
            [:> "penjar:stroke"
             #js {:penjar:stroke-color          (cond
                                                  (some? (:stroke-color-gradient stroke))
                                                  (str/format "url(#%s)" (str "stroke-color-gradient-" render-id "-" index))

                                                  :else
                                                  (d/name (:stroke-color stroke)))
                  :key                          (swap! internal-counter inc)
                  :penjar:stroke-image-id       (when (:stroke-image stroke) stroke-image-id)
                  :penjar:stroke-color-ref-file (d/name (:stroke-color-ref-file stroke))
                  :penjar:stroke-color-ref-id   (d/name (:stroke-color-ref-id stroke))
                  :penjar:stroke-opacity        (d/name (:stroke-opacity stroke))
                  :penjar:stroke-style          (d/name (:stroke-style stroke))
                  :penjar:stroke-width          (d/name (:stroke-width stroke))
                  :penjar:stroke-alignment      (d/name (:stroke-alignment stroke))
                  :penjar:stroke-cap-start      (d/name (:stroke-cap-start stroke))
                  :penjar:stroke-cap-end        (d/name (:stroke-cap-end stroke))}]))]))))

(defn- export-interactions-data [{:keys [interactions]}]
  (when-let [interactions (seq interactions)]
    (mf/html
     [:> "penjar:interactions" #js {}
      (for [interaction interactions]
        [:> "penjar:interaction"
         #js {:penjar:event-type (d/name (:event-type interaction))
              :penjar:action-type (d/name (:action-type interaction))
              :penjar:delay ((d/nilf str) (:delay interaction))
              :penjar:destination ((d/nilf str) (:destination interaction))
              :penjar:overlay-pos-type ((d/nilf d/name) (:overlay-pos-type interaction))
              :penjar:overlay-position-x ((d/nilf get-in) interaction [:overlay-position :x])
              :penjar:overlay-position-y ((d/nilf get-in) interaction [:overlay-position :y])
              :penjar:url (:url interaction)
              :key (swap! internal-counter inc)
              :penjar:close-click-outside ((d/nilf str) (:close-click-outside interaction))
              :penjar:background-overlay ((d/nilf str) (:background-overlay interaction))
              :penjar:preserve-scroll ((d/nilf str) (:preserve-scroll interaction))}])])))


(defn- export-layout-container-data
  [{:keys [layout
           layout-flex-dir
           layout-gap
           layout-gap-type
           layout-wrap-type
           layout-padding-type
           layout-padding
           layout-justify-items
           layout-justify-content
           layout-align-items
           layout-align-content
           layout-grid-dir
           layout-grid-rows
           layout-grid-columns
           layout-grid-cells]}]

  (when layout
    (mf/html
     [:> "penjar:layout"
      #js {:penjar:layout (d/name layout)
           :penjar:layout-flex-dir (d/name layout-flex-dir)
           :penjar:layout-gap-type (d/name layout-gap-type)
           :penjar:layout-gap-row (:row-gap layout-gap)
           :penjar:layout-gap-column (:column-gap layout-gap)
           :penjar:layout-wrap-type (d/name layout-wrap-type)
           :penjar:layout-padding-type (d/name layout-padding-type)
           :penjar:layout-padding-p1 (:p1 layout-padding)
           :penjar:layout-padding-p2 (:p2 layout-padding)
           :penjar:layout-padding-p3 (:p3 layout-padding)
           :penjar:layout-padding-p4 (:p4 layout-padding)
           :penjar:layout-justify-items (d/name layout-justify-items)
           :penjar:layout-justify-content (d/name layout-justify-content)
           :penjar:layout-align-items (d/name layout-align-items)
           :penjar:layout-align-content (d/name layout-align-content)
           :penjar:layout-grid-dir (d/name layout-grid-dir)}

      [:> "penjar:grid-rows" #js {}
       (for [[idx {:keys [type value]}] (d/enumerate layout-grid-rows)]
         [:> "penjar:grid-track"
          #js {:penjar:index idx
               :key (swap! internal-counter inc)
               :penjar:type (d/name type)
               :penjar:value value}])]

      [:> "penjar:grid-columns" #js {}
       (for [[idx {:keys [type value]}] (d/enumerate layout-grid-columns)]
         [:> "penjar:grid-track"
          #js {:penjar:index idx
               :key (swap! internal-counter inc)
               :penjar:type (d/name type)
               :penjar:value value}])]

      [:> "penjar:grid-cells" #js {}
       (for [[_ {:keys [id
                        area-name
                        row
                        row-span
                        column
                        column-span
                        position
                        align-self
                        justify-self
                        shapes]}] layout-grid-cells]
         [:> "penjar:grid-cell"
          #js {:penjar:id id
               :key (swap! internal-counter inc)
               :penjar:area-name area-name
               :penjar:row row
               :penjar:row-span row-span
               :penjar:column column
               :penjar:column-span column-span
               :penjar:position (d/name position)
               :penjar:align-self (d/name align-self)
               :penjar:justify-self (d/name justify-self)
               :penjar:shapes (str/join " " shapes)}])]])))

(defn- export-layout-item-data
  [{:keys [layout-item-margin
           layout-item-margin-type
           layout-item-h-sizing
           layout-item-v-sizing
           layout-item-max-h
           layout-item-min-h
           layout-item-max-w
           layout-item-min-w
           layout-item-align-self
           layout-item-absolute
           layout-item-z-index]}]

  (when (or layout-item-margin
            layout-item-margin-type
            layout-item-h-sizing
            layout-item-v-sizing
            layout-item-max-h
            layout-item-min-h
            layout-item-max-w
            layout-item-min-w
            layout-item-align-self
            layout-item-absolute
            layout-item-z-index)
    (mf/html
     [:> "penjar:layout-item"
      #js {:penjar:layout-item-margin-m1 (:m1 layout-item-margin)
           :penjar:layout-item-margin-m2 (:m2 layout-item-margin)
           :penjar:layout-item-margin-m3 (:m3 layout-item-margin)
           :penjar:layout-item-margin-m4 (:m4 layout-item-margin)
           :penjar:layout-item-margin-type (d/name layout-item-margin-type)
           :penjar:layout-item-h-sizing (d/name layout-item-h-sizing)
           :penjar:layout-item-v-sizing (d/name layout-item-v-sizing)
           :penjar:layout-item-max-h layout-item-max-h
           :penjar:layout-item-min-h layout-item-min-h
           :penjar:layout-item-max-w layout-item-max-w
           :penjar:layout-item-min-w layout-item-min-w
           :penjar:layout-item-align-self (d/name layout-item-align-self)
           :penjar:layout-item-absolute layout-item-absolute
           :penjar:layout-item-z-index layout-item-z-index}])))


(mf/defc export-data
  [{:keys [shape]}]
  (let [props (-> (obj/create) (add-data shape) (add-library-refs shape))]
    [:> "penjar:shape" props
     (export-shadow-data           shape)
     (export-blur-data             shape)
     (export-exports-data          shape)
     (export-svg-data              shape)
     (export-interactions-data     shape)
     (export-fills-data            shape)
     (export-strokes-data          shape)
     (export-grid-data             shape)
     (export-layout-container-data shape)
     (export-layout-item-data      shape)]))

