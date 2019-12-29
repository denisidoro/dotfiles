(ns memento.controllers.parser
  (:require [memento.controllers.sqlite :as sqlite]
            [memento.logic.parser :as l]))

(defn ^:private library-data!
  [library-name ds libraries]
  (let [library (l/one-library library-name libraries)
        fields (sqlite/execute! ds (l/fields-query-vec library))
        rows (sqlite/execute! ds (l/row-query-vec fields))
        relations (->> (sqlite/execute! ds (l/relation-query-vec library))
                       (l/relation-mapper rows))
        relations2 (l/relation-types rows libraries)
        field-map (l/gen-field-map fields relations relations2 rows)
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
  (let [conn (sqlite/connect! "/Users/denis.isidoro/dev/mem/resources/memento.db")
        libraries (->> (sqlite/execute! conn (l/library-query-vec))
                       (map l/library-internal))]
    (all-entries-indexed! conn libraries)))

