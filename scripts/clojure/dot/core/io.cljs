(ns dot.core.io
  (:require [lumo.io :as io]))

(def slurp! io/slurp)

(defn slurp
  [filename]
  (try (slurp! filename)
       (catch :default e nil)))
