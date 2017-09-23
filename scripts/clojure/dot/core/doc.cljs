(ns dot.core.doc)

(def neodoc (js/require "neodoc"))

(defn parse
  [doc args]
  (let [opts (clj->js {:argv (or args [])})]
    (-> neodoc
        (.run doc opts)
        (js->clj :keywordize-keys true))))
