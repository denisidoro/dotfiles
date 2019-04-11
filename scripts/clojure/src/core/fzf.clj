(ns core.fzf
  (:require [clojure.java.io :as io])
  (:import (java.lang ProcessBuilder$Redirect)))

(defn with-filter
  "Filtering with fzf"
  [command coll]
  (let [sh  (or (System/getenv "SHELL") "sh")
        pb  (doto
              (ProcessBuilder. [sh "-c" command])
              (.redirectError
                (ProcessBuilder$Redirect/to (clojure.java.io/file "/dev/tty"))))
        p   (.start pb)
        in  (io/reader (.getInputStream p))
        out (io/writer (.getOutputStream p))]
    (binding [*out* out]
      (try (doseq [e coll] (println e))
           (.close out)
           (catch Exception e)))
    (take-while identity (repeatedly #(.readLine in)))))

(defn first-filter
  [command coll]
  (first (with-filter command coll)))
