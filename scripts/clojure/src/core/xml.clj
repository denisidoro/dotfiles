(ns core.xml
  (:require [clojure.xml :as x]
            [clojure.string :as str]
            [core.xml.from-hiccup :as hiccup.from]
            [core.xml.to-hiccup :as hiccup.to])
  (:import (java.io ByteArrayInputStream)))

(defn xml-str->map
  ([str] (xml-str->map str "UTF-8"))
  ([str ^String encoding]
   (-> str
       (str/replace #"\\\"" "\"")
       (.getBytes encoding)
       ByteArrayInputStream.
       x/parse)))

(defn xml-str->hiccup
  [xml-str]
  (-> xml-str
      xml-str->map
      hiccup.to/xml-map->hiccup))

(def xml-map->hiccup
  hiccup.to/xml-map->hiccup)

(def hiccup->xml-str
  hiccup.from/render)
