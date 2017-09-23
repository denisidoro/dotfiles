(ns dot.core.read
  (:require [cljs.reader :as reader]
       			[cognitect.transit :as transit]))

(def ^:private ^:const handlers
  {})

(defn ^:private r [] 
	(transit/reader :json {:handlers handlers}))

(defn transit
  [json-transit]
  (transit/read (r) json-transit))

(defn json
  [json] 
  (js->clj (.parse js/JSON json) :keywordize-keys true))

(def edn cljs.reader/read-string)
