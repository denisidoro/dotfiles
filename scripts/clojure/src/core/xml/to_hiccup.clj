(ns core.xml.to-hiccup
  (:require [clojure.walk :as walk]
            [clojure.xml :as x]
            [clojure.string :as str])
  (:import (clojure.lang Keyword)))

(declare xml->hiccup*)

(defn ^:private keyword->atomic-value
  [x]
  (if (-> x name (str/includes? ":"))
    (-> x name (str/replace ":" "/") keyword)
    x))

(defn ^:private str->atomic-value
  [x]
  (cond
    (re-find #"^-?\d+$" x)
    (try
      (-> x bigint int)
      (catch Exception _
        (bigint x)))

    (re-find #"^-?\d+\.?\d*$" x)
    (read-string x)

    (re-matches #"^\w[\d\w]*:\w[\d\w]*$" x)
    (-> x (str/replace ":" "/") keyword)

    :else
    x))

(defn ^:private with-attrs
  [x attrs]
  (if (nil? attrs)
    x
    (conj x attrs)))

(defn ^:private with-content
  [x content]
  (if (empty? content)
    x
    (->> content
         (map xml->hiccup*)
         (concat x)
         vec)))

(defprotocol ToValue
  (^String to-value [x]))

(extend-protocol ToValue
  Keyword
  (to-value [x] (keyword->atomic-value x))
  String
  (to-value [x] (str->atomic-value x))
  Object
  (to-value [x] x))

(defn ^:private xml->hiccup*
  [xml]
  (if-not (map? xml)
    xml
    (let [{:keys [tag attrs content]} xml]
      (-> [tag]
          (with-attrs attrs)
          (with-content content)))))

(defn xml-map->hiccup
  [xml]
  (->> xml
       xml->hiccup*
       (walk/postwalk to-value)))

(defn xml-str->map
  ([str] (xml-str->map str "UTF-8"))
  ([str encoding] (-> str
                      (str/replace #"\\\"" "\"")
                      (.getBytes encoding)
                      java.io.ByteArrayInputStream.
                      x/parse)))

(defn xml-str->hiccup
  [xml-str]
  (-> xml-str
      xml-str->map
      xml-map->hiccup))
