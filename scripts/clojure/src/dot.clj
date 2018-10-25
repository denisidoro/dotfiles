(ns dot
  (:require [data :as data])
  (:gen-class))

(defn -main [first-arg & other-args]
  (let [fn (case first-arg
             "data" data/-main
             #(print "Unable to find script"))]
    (apply fn other-args)))
