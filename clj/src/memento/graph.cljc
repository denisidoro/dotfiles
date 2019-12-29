(ns memento.graph
  (:require [com.wsscode.pathom.core :as p]
            [com.wsscode.pathom.connect :as pc]
            [quark.collection.ns :as ns]
            [memento.controllers.parser :as c.parser]
            [memento.logic.query :as l.query]
            [clojure.core.async :as async]))

(def entries
  (c.parser/connect-and-get-entries!))

(defn one-entry-resolver
  [ns-kw output]
  (let [memid-kw (keyword (name ns-kw) "memid")
        sym (symbol #_(name (ns-name *ns*)) (str "one-" (name ns-kw) "-resolver"))]
    (pc/resolver sym
      {::pc/input  #{memid-kw}
       ::pc/output output}
      (fn [env params]
        (l.query/get-by-key+id entries memid-kw (memid-kw params))))))

(defn all-entries-resolver
  [ns-kw]
  (let [memid-kw (keyword (name ns-kw) "memid")
        all-kw (keyword (name ns-kw) "all")
        sym (symbol #_(name (ns-name *ns*)) (str "all-" (name ns-kw) "-resolver"))]
    (pc/resolver
      sym
      {::pc/input  #{}
       ::pc/output [{all-kw [memid-kw]}]}
      (fn
        [env params]
        {all-kw (->> (l.query/all-ids-for-key entries memid-kw)
                     (map (fn [id] {memid-kw id})))}))))

(def config
  {:rf             #{:name :issuer :bank :start-date :start-amount}
   :fundo          #{:name :bank}
   :bank           #{:name}
   :fundo-movement #{:date :fundo}
   :stock          #{:name :code}})

(def my-resolvers
  (concat (->> config
               (mapcat (fn [[k v]]
                         [(one-entry-resolver k (-> v (ns/namespaced k) vec))
                          (all-entries-resolver k)])))
          []))

(def parser
  (p/parallel-parser
    {::p/env     {::p/reader               [p/map-reader
                                            pc/parallel-reader
                                            pc/open-ident-reader
                                            p/env-placeholder-reader]
                  ::p/placeholder-prefixes #{">"}}
     ::p/mutate  pc/mutate-async
     ::p/plugins [(pc/connect-plugin {::pc/register my-resolvers})
                  p/error-handler-plugin
                  p/trace-plugin]}))

(defn query
  [& args]
  (apply parser args))

(query {} [{[:rf/memid ")%b&R4HVD:P(2zsVy!F@"] [:rf/issuer {:rf/bank [:bank/name]}]}])
(query {} [{:rf/all [:rf/start-date :rf/start-amount {:rf/bank [:bank/name]}]}])

