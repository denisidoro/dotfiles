(ns memento.types.core)

(deftype Ref [id])

(defn ref?
  [x]
  (instance? Ref x))
