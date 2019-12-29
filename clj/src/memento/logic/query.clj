(ns memento.logic.query
  (:require [quark.collection.map :as map]
            [memento.types.core :as types]))

(defn ^:private get-by-id*
  [all-xs id]
  (as-> all-xs it
        (vals it)
        (apply merge it)
        (get it id)))

(defn get-by-key+id*
  [all-xs k id]
   (get-in all-xs [k id]))

(defn tap
    [x]
  (println x)
  x)

(defn resolve-refs
  [m all-xs]
  (map/map-vals
    (fn [x]
      (if (types/ref? x)
        (->> (get-by-key+id* all-xs (.-key x) (.-id x))
             (map/filter-keys #(-> % name (= "memid"))))
        x))
    m))

(defn get-by-id
  [all-xs id]
  (-> (get-by-id* all-xs id)
      (resolve-refs all-xs)))

(defn get-by-key+id
  [all-xs k id]
  (-> (get-in all-xs [k id])
      (resolve-refs all-xs)))

(defn all-ids-for-key
  [all-xs k]
  (-> all-xs
      (get k)
      keys))
