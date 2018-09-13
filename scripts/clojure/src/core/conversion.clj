(ns core.conversion
  (:require [clojure.data.json :as json]))

(def str->edn
  read-string)

(defn json->edn
  [& args]
  (apply json/read-str (concat (take 1 args) [:key-fn keyword] (rest args))))

(def edn->json
  json/write-str)
