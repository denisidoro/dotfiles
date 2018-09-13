(ns core.collection)

(defn indices
  [f coll]
  (keep-indexed #(when (f %2) %1) coll))

(defn first-index
  [f coll]
  (first (indices f coll)))

(defn map-keys
  [f m]
  (into {} (for [[k v] m] [(f k) v])))

(defn map-vals
  [f m]
  (into {} (for [[k v] m] [k (f v)])))

(defn filter-keys
  [f coll]
  (->> coll
       (filter (fn [[k v]] (f k)))
       (into {})))

(defn filter-values
  [f coll]
  (->> coll
       (filter (fn [[k v]] (f v)))
       (into {})))

(defn deep-merge
  "Recursively merges maps.
   If the first parameter is a keyword it tells the strategy to
   use when merging non-map collections. Options are
   - :replace, the default, the last value is used
   - :into, if the value in every map is a collection they are concatenated
     using into. Thus the type of (first) value is maintained."
  {:arglists '([strategy & values] [values])}
  [& values]
  (let [[values strategy] (if (keyword? (first values))
                            [(rest values) (first values)]
                            [values :replace])]
    (cond
      (every? map? values)
      (apply merge-with (partial deep-merge strategy) values)

      (and (= strategy :into) (every? coll? values))
      (reduce into values)

      :else
      (last values))))

(defn namespaced
  [ns k]
  (->> k
       name
       (keyword ns)))

(defn unnamespaced
  [k]
  (-> k
      name
      keyword))

(defn assoc-if
  ([m k v]
   (-> m (cond-> v (assoc k v))))
  ([m k v & kvs]
   (let [ret (assoc-if m k v)]
     (if kvs
       (when (next kvs)
         (recur ret (first kvs) (second kvs) (nnext kvs)))
       ret))))

(defn safe-get
  [coll key & args]
  (if (coll? key)
    (apply get-in coll (vec key) args)
    (apply get coll key args)))
