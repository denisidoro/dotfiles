(ns dot.tmp
  (:require [dot.core.io :as io]))

(def params
		{:firstName "John" 
	 :lastName "Doe"})

(defn -main
  [& args]
  (-> (io/GET "http://api.icndb.com/jokes/random" {:output "myfile.txt"}) print))
