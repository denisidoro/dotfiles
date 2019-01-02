(ns data
  (:require [core.conversion :as conversion]
            [core.documentation :as doc]
            [core.xml :as xml]
            [core.print :as print]))

(set! *default-data-reader-fn* tagged-literal)

(def ^:constant version
  "0.1.0")

(def ^:constant help-string
  "Data structure helpers

  Usage:
    data [options]

  Options:
    -c --color             Colorized output
    -i --input <input>     Input format
    -o --output <output>   Output format
    -g --get <get>         get-in keyword vector
    -e --eval <eval>       Arbitrary function

  Examples:
    echo '{:foo 123}' | data edn
    echo '{\"a\": 123}' | data -i json -c
    echo '[:head]' | data -o xml
    echo '<head/>' | data -i xml
    echo '{:foo 123}' | data -g :foo
    echo '{:foo 123}' | data -e '#(-> % :foo inc)'")

(defn -main [& args]
  (let [options   (doc/parse help-string version args)
        parser    slurp
        input-f   (-> options :--input first)
        output-f  (-> options :--output first)
        get'      (:--get options)
        eval'     (:--eval options)
        converter (case input-f
                    \j conversion/json->edn
                    \x xml/xml-str->hiccup
                    (cond
                      (= output-f \x) (comp xml/hiccup->xml-str conversion/str->edn)
                      (= output-f \j) (comp conversion/edn->json conversion/str->edn)
                      :else conversion/str->edn))
        callback  (cond
                    get' #(get-in % (conversion/str->edn (str "[" get' "]")))
                    eval' (-> eval' read-string eval)
                    :else identity)
        printer   (cond
                    (:--color options) print/color
                    (= output-f \x) print/simple
                    (= output-f \j) print/simple
                    :else print/pretty)]
    (-> *in* parser converter callback printer)))

