(ns memento.controllers.sqlite
  (:require #?@(:clj [[next.jdbc :as jdbc]
                      [next.jdbc.result-set :as rs]])
            [memento.logic.parser :as l]))

#?(:cljs
   (do (def sqlite3
         (js/require "better-sqlite3"))

       (defn all
         [conn [arg0 arg1 arg2]]
         (cond
           arg2 (.all conn arg0 arg1 arg2)
           arg1 (.all conn arg0 arg1)
           arg0 (.all conn arg0)
           :else (.all conn))))

   :clj
   (do (def ^:private exec-opts
         {:builder-fn rs/as-unqualified-maps})))

(defn execute!
  [conn sql-params]
  #?(:cljs
     (as-> conn it
           (.prepare it (first sql-params))
           (all it (rest sql-params))
           (map #(js->clj % :keywordize-keys true) it))

     :clj
     (jdbc/execute! conn sql-params exec-opts)))

(defn connect!
  [filename]
  #?(:cljs
     (sqlite3 filename #js {})

     :clj
     (let [db {:dbtype "sqlite" :dbname filename}]
       (jdbc/get-datasource db))))
