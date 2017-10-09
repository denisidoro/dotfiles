(ns dot.core.io
  (:require [lumo.io :as io]
            [dot.core.shell :as sh]
            [dot.core.utils :as utils]
            [clojure.string :as str]))

;; Local storage

(def slurp! io/slurp)

(defn slurp
  [filename]
  (try (slurp! filename)
       (catch :default e nil)))

;; HTTP

(defn ^:private request-header?
  [v]
  (str/starts-with? v ">"))

(defn ^:private response-header?
  [v]
  (str/starts-with? v "<"))

(defn ^:private separator?
  [v]
  (-> v str/trim count (< 2)))

(defn ^:private header->key+value
  [header]
  (let [colon-index  (str/index-of header ":")
        header-key   (subs header 2 colon-index)
        header-value (-> header (subs (inc colon-index)) str/trim)]
    [header-key header-value]))

(defn ^:private query-str
  [m]
  (str/join "&" (for [[k v] m] (str (name k) "=" (js/encodeURIComponent v)))))

(defn ^:private parse-cmd-output
  [cmd-output]
  (let [lines                 (-> cmd-output :stderr str str/split-lines)
        request-start         (utils/first-index request-header? lines)
        response-start        (utils/first-index response-header? lines)
        response-header-end   (utils/first-index (every-pred separator? response-header?) lines)
        response-header-count (- response-header-end response-start 1)
        request-header-count  (- response-start request-start 2)
        response-headers      (->> lines (drop (inc response-start)) (take response-header-count) (map header->key+value) (into {}))
        request-headers       (->> lines (drop (inc request-start)) (take request-header-count) (map header->key+value) (into {}))
        [method url]          (some-> lines (get request-start) (subs 2) (str/split #"\s"))
        status                (-> lines (get response-start) (str/split #"\s") (get 2) js/parseInt)
        body                  (-> cmd-output :stdout str)]
    {:headers response-headers
     :request (assoc request-headers :method method :url url)
     :body    body
     :status  status}))

(defn ^:private header-args
  [headers]
  (reduce-kv #(conj %1 "-H" (str %2 ": " %3)) [] headers))

(defn ^:private any->str
  [v]
  (condp #(%1 %2) v
    string? v
    keyword? (name v)
    (str v)))

(def ^:private map-keys-str
	(partial utils/map-keys any->str))

(defn ^:private sanitize
  [method url {:keys [query-params request-params data type headers] :or {headers {}} :as options}]
  (cond-> (assoc options :method method :url url)
          query-params (update :url #(->> query-params map-keys-str query-str (str % "?")))
          type (assoc-in [:headers "Content-Type"] type)
          headers (update :headers map-keys-str)
          request-params (update :request-params #(->> % map-keys-str clj->js))
          (keyword? method) (update :method (comp str/upper-case name))))

(defn ^:private curl-args
  [{:keys [method url data headers request-params output]}]
  (cond-> ["-vs" "-X" method]
          request-params (conj "--data" (js/JSON.stringify request-params))
          (seq headers) (#(-> (concat % (header-args headers)) vec))
          true (conj url)
          output (conj "--output" output)))

(defn request
  ([method url]
   (request method url {}))
  ([method url options]
   (->> (sanitize method url options)
        curl-args
        (apply sh/curl)
        parse-cmd-output)))

(def GET (partial request "GET"))
(def POST (partial request "POST"))
(def PUT (partial request "PUT"))
(def PATCH (partial request "PATCH"))
(def DELETE (partial request "DELETE"))
