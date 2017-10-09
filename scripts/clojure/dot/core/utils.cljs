(ns dot.core.utils)

(defn indices [f coll]
  (keep-indexed #(when (f %2) %1) coll))

(defn first-index [f coll]
  (first (indices f coll)))

(defn map-keys [f m] 
	(into {} (for [[k v] m] [(f k) v])))

(defn map-vals [f m] 
	(into {} (for [[k v] m] [k (f v)])))
