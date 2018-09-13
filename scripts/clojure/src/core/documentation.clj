(ns core.documentation
  (:require [core.collection :as coll])
  (:import (org.docopt Docopt)
           (java.util ArrayList List)))

(defn ^:private as-array-list
  [args]
  (let [alist (ArrayList.)]
    (doseq [a args] (.add alist ^String a)) alist))

(defn parse
  [^String help version args]
  (->> (-> help
           Docopt.
           (.withVersion ^String (or version "unknown"))
           (.parse ^List (as-array-list args)))
       (coll/map-keys keyword)))
