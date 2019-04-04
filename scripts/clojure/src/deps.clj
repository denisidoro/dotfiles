;; based on https://gist.github.com/swlkr/3f346c66410e5c60c59530c4413a248e
;; by https://github.com/swlkr
(ns deps
   (:require [clojure.pprint :as pprint]))

(defn project-clj-map [filename]
  (->> (slurp filename)
       (read-string)
       (drop 1)
       (partition 2)
       (map vec)
       (into {})))

(defn lein-deps [filename]
  (let [project-clj (project-clj-map filename)]
    (get project-clj :dependencies)))

(defn edn-dep [lein-dep]
  (let [[id version] lein-dep]
    {id {:mvn/version version}}))

(defn edn-deps [lein-deps]
  (let [deps (into {} (map edn-dep lein-deps))]
    {:deps deps}))

(defn pprint-write [out-file m]
  (with-open [w (clojure.java.io/writer out-file)]
    (binding [*out* w]
      (pprint/write m))))

(defn print-edn-deps [path]
  (->> path
       lein-deps
       edn-deps
       pprint/pprint))

(defn -main [& args]
  (-> args first print-edn-deps str))
