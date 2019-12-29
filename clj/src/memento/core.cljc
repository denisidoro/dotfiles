(ns memento.core
  (:require [clojure.string :as str]
  [memento.controllers.parser :as c.parser]
  [memento.logic.query :as l.query] ))

(defn -main
  [& args]
  (println "before")
  (println (-> (c.parser/connect-and-get-entries!)
               (l.query/get-by-id "HNAn8<u6Q[S%R2EqZ]sW")
               ;count
               ))
  (println "after")
  42)

(-main)