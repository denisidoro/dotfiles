(ns dot.edn
  (:require [dot.core.doc :as doc]
            [dot.core.stdin :as stdin]
            [dot.core.print :as print]
            [dot.core.read :as read]))

(def ^:private looks-like-keyword? (partial re-find #"^:[\w\-\./_:]+$"))

(defn ^:private parse-arg
  [arg]
  (cond
    (int? arg) arg
    (looks-like-keyword? arg) (-> arg (.substr 1) keyword)
    :else (str arg)))

(defn ^:private infer-callback
  [options]
  (let [parsed-args #(some->> options :<args> (mapv parse-arg))]
    (cond
      (:get options) #(get-in % (parsed-args))
      (:assoc options) #(apply assoc (into [%] (parsed-args)))
      (:dissoc options) #(apply dissoc (into [%] (parsed-args)))
      :else identity)))

(defn ^:private infer-parser
  [format]
  (case format
    "transit" read/transit
    "json" read/json
    read/edn))

(defn ^:private infer-printer
  [options]
  (if (:--color options)
    print/pprint
    prn))

(defn -main

"A lightweight command-line EDN processor

Usage:
   edn [options]
   edn [options] get <args>...
   edn [options] (assoc|dissoc) <args>...

Options:
   --format <format>   Input format [default: edn]
   --color <color>     Colorized pretty-print [default: true]

Examples:
   echo '{:foo 123}' | dot clojure edn
   echo '{:foo 123}' | dot clojure edn get :foo
   echo '{:foo 123}' | dot clojure edn assoc :bar 456
   echo '{\"a\": 123}' | dot clojure edn --format json
   echo '' | dot clojure edn --format transit
   echo '{:foo 123}' | dot clojure edn --color false"

  [& args]
  (let [options  (-> #'-main meta :doc (doc/parse args))
        parser   (-> options :--format infer-parser)
        callback (infer-callback options)
        printer  (infer-printer options)]
    (stdin/handler (comp printer callback parser str))))
