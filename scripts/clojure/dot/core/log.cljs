(ns dot.core.log
  (:require [dot.core.shell :as shell]))

(defn success
  [msg]
  (println (str "\033[2m✓ " msg "\033[0m")))

(defn failure
  [msg]
  (println (str "\033[1m✕ " msg "\033[0m")))

(defn tap
  [x]
  (print x)
  x)
