(ns core.xml.from-hiccup
  (:require [clojure.string :as str])
  (:import [clojure.lang IPersistentVector ISeq Named Keyword]))

(defprotocol ToString
  (^String to-str [x]))

(extend-protocol ToString
  Keyword
  (to-str [k] (if (simple-keyword? k)
                (name k)
                (str (namespace k) ":" (name k))))
  Object
  (to-str [x] (str x))
  nil
  (to-str [_] ""))

(defn ^String ^:private as-str
  [& xs]
  (apply str (map to-str xs)))

(defn ^:private escape-html
  [text]
  (-> text
      as-str
      (str/escape {\> "&gt;"
                   \< "&lt;"
                   \& "&amp;"
                   \" "&quot;"
                   \' "&apos;"})))

(defn ^:private render-map [value]
  (->> value
       (map (fn [[k v]] (str (as-str k) ":" v ";")))
       sort
       (apply str)))

(defn ^:private render-attr-value [value]
  (cond
    (map? value) (render-map value)
    (sequential? value) (str/join " " value)
    :else value))

(defn ^:private xml-attribute [name value]
  (str " " (as-str name) "=\"" (escape-html (render-attr-value value)) "\""))

(defn ^:private render-attribute [[name value]]
  (cond
    (true? value) (xml-attribute name name)
    (not value) ""
    :else (xml-attribute name value)))

(defn render-attr-map
  [attrs]
  (apply str (sort (map render-attribute attrs))))

(defn normalize-element
  [[tag & content]]
  (let [tag-str   (as-str tag)
        map-attrs (first content)]
    (if (map? map-attrs)
      [tag-str map-attrs (next content)]
      [tag-str {} content])))

(defprotocol XmlRenderer
  (render [this]))

(defn render-element
  [element]
  (let [[tag attrs content] (normalize-element element)]
    (if content
      (str "<" tag (render-attr-map attrs) ">"
           (render content)
           "</" tag ">")
      (str "<" tag (render-attr-map attrs) " />"))))

(extend-protocol XmlRenderer
  IPersistentVector
  (render [this]
    (render-element this))
  ISeq
  (render [this]
    (apply str (map render this)))
  String
  (render [this]
    (str this))
  Named
  (render [this]
    (escape-html (name this)))
  Object
  (render [this]
    (escape-html (str this)))
  nil
  (render [this]
    ""))

(defn map->hiccup-form
  [tag props children-map]
  (reduce (fn [current kv] (into current (vector kv))) [tag props] children-map))
