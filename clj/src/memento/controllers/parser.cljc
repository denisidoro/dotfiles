(ns memento.controllers.parser
  (:require #?@(:clj  [[next.jdbc :as jdbc]
                       [next.jdbc.result-set :as rs]])
            [memento.logic.parser :as l]))

#?(:cljs 
  (do (def sqlite3
    (js/require "better-sqlite3"))

    (defn all
      [conn [arg0 arg1 arg2]]
      (cond
         arg2  (.all conn arg0 arg1 arg2)
         arg1  (.all conn arg0 arg1)
         arg0  (.all conn arg0)
         :else (.all conn))))

     :clj 
     (do (def ^:private exec-opts 
      {:builder-fn rs/as-unqualified-maps})))


(defn ^:private execute!
  [conn sql-params]
   #?(:cljs 
      (as-> conn it
        (.prepare it (first sql-params))
        (all it (rest sql-params))
        (map #(js->clj % :keywordize-keys true) it))

     :clj 
     (jdbc/execute! conn sql-params exec-opts)))

(defn ^:private connect!
  [filename]
  #?(:cljs 
      (sqlite3 filename #js {})

     :clj 
     (let [db {:dbtype "sqlite" :dbname filename}]
      (jdbc/get-datasource db))))

(defn ^:private library-data!
  [library-name ds libraries]
  (let [library (l/one-library library-name libraries)
        fields (execute! ds (l/fields-query-vec library))
        rows (execute! ds (l/row-query-vec fields))
        relations (->> (execute! ds (l/relation-query-vec library))
                       l/relation-mapper)
        field-map (l/gen-field-map fields relations rows)
        entries (l/rows->entries rows field-map)
        schema (l/gen-schema fields field-map)]
    {:entries      entries
     :schema       schema
     :library-id   (:id library)
     :library-name (:name library)}))

(defn ^:private library-entries!
  [library-name ds libraries]
  (->> (library-data! library-name ds libraries)
       l/library-data->entries))

(defn ^:private all-entries-indexed!
  [ds libraries]
  (->> libraries
       (map (fn [{:keys [name]}] [(l/key-mapper name "memid") (library-entries! name ds libraries)]))
       (into {})))

(defn connect-and-get-entries!
  []
  (let [conn (connect! "/home/dns/.dotfiles/clj/resources/memento.db")
        libraries (->> (execute! conn (l/library-query-vec))
                       (map l/library-internal))]
    (all-entries-indexed! conn libraries)))

