(ns curl
  (:require [core.fzf :as fzf]
            [clojure.java.shell :refer [sh]]
            [core.ansi :as ansi]
            [clojure.string :as str]))

(defn services
  []
  (-> (sh "ls" "/")
      :out
      str
      str/split-lines))

(defn shards
  []
  (range 0 6))

(defn fzf
  [coll]
  (fzf/first-filter "fzf --ansi --height 15" coll))

(def argmap
  {:service/name services
   :infra/shard  shards})

(defn as-str
  [x]
  (if (keyword? x)
    (-> x str (subs 1))
    (str x)))

(defn set-arg
  []
  (let [k    (->> argmap keys (map as-str) fzf keyword)
        f    (get argmap k)
        coll (f)]
    [k (fzf coll)]))

(defn -main
  [& args]
  (set-arg)
  (set-arg)
  (System/exit 0))
