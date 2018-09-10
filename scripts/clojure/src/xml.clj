(ns xml
  (:require [clojure.pprint :refer [pprint]]
            [core.xml.to-hiccup :as hiccup.to]))

(defn -main [& args]
  (pprint (hiccup.to/xml-str->hiccup (slurp *in*))))
