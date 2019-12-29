(ns memento.logic.parser
  (:require [clojure.string :as str]
            [quark.collection.seq :as seq]
            [quark.conversion.data :as data]
            [quark.collection.map :as map]
            #_[quark.time.core :as time]
            [memento.types.core :as types]))

(defn library-internal
  [{:keys [UUID TITLE]}]
  {:id   UUID
   :name TITLE})

(defn gen-field-map
  [fields relations rows]
  (->> fields
       (map (fn [{:keys [title UUID type_code]}]
              (let [val-fn (case type_code

                             "ft_str_list"
                             (->> rows
                                  (seq/find-first #(-> % :ownerUUID (= UUID)))
                                  :stringContent
                                  data/json->edn
                                  :sl
                                  (map (fn [{:keys [c t]}] [c t]))
                                  (into {}))

                             "ft_lib_entry"
                             relations

                             "ft_date"
                             identity
                             ; #(-> % bigint long time/from-millis)


                             identity)]
                [UUID {:title title :val-fn val-fn}])))
       (into {})))

(defn owner-mapper
  [field-map xs]
  (->> xs
       (map
         (fn [{:keys [templateUUID intContent stringContent realContent]}]
           (let [v (or stringContent intContent realContent)
                 {:keys [title val-fn]} (get field-map templateUUID)]
             [title
              (val-fn v)])))
       (into {})))

(defn merge-id
  [[id m]]
  (assoc m "MemID" id))

(defn without-nil-values
  [x]
  (map/filter-vals identity x))

(defn fields-query-vec
  [library]
  ["SELECT * FROM tbl_flex_template WHERE LIB_UUID = ? AND type_code != 'ft_subheader'" (:id library)])

(defn one-library
  [library-name libraries]
  (seq/find-first #(-> % :name (= library-name)) libraries))

(defn row-query-vec
  [fields]
  (let [field-ids (map :UUID fields)
        field-ids-str (->> field-ids (map (fn [x] (str "'" x "'"))) (str/join ", "))]
    [(str "SELECT * FROM tbl_flex_content2 WHERE templateUUID IN (" field-ids-str ")")]))

(defn relation-query-vec
  [library]
  ["SELECT * FROM tbl_relations WHERE lib_uuid = ?" (:id library)])

(defn relation-mapper
  [xs]
  (->> xs
       (map (fn [{:keys [rel_uuid slave_item_uuid]}] [rel_uuid (types/->Ref slave_item_uuid)]))
       (into {})))

(defn rows->entries
  [rows field-map]
  (->> rows
       (remove (fn [{:keys [ownerUUID templateUUID]}] (= ownerUUID templateUUID)))
       (group-by :ownerUUID)
       (map/map-vals (partial owner-mapper field-map))
       (map (comp without-nil-values merge-id))))

(defn gen-schema
  [fields field-map]
  (->> fields
       (map (fn [{:keys [title UUID type_code]}]
              (let [primitive (case type_code

                                "ft_str_list"
                                (->> (get field-map UUID)
                                     :val-fn
                                     vals
                                     set)

                                (keyword type_code))]
                [title primitive])))
       (into {})))

(defn library-query-vec
  []
  ["SELECT * FROM tbl_library"])

(defn kw-friendly-str
  [x]
  (as-> x it
        (str/replace it " " "-")
        (str/lower-case it)))

(defn key-mapper
  [ns x]
  (as-> x it
        (kw-friendly-str it)
        (keyword (kw-friendly-str ns) it)))

(defn entry-mapper
  [library-name x]
  (map/map-keys (partial key-mapper library-name) x))

(defn library-data->entries
  [{:keys [library-name entries]}]
  (->> entries
       (map (fn [x] [(get x "MemID") x]))
       (into {})
       (map/map-vals (partial entry-mapper library-name))))
