(ns memento.types.core)

(deftype Ref [key id])

(defn ref?
  [x]
  (instance? Ref x))
