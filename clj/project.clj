(defproject memento "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url  "http://www.eclipse.org/legal/epls-v10.html"}
  :main memento.core
  :dependencies [[org.clojure/clojure "1.10.1"]
                 [seancorfield/next.jdbc "1.0.12"]
                 [org.xerial/sqlite-jdbc "3.28.0"]
                 [denisidoro/quark "0.9.1"]
                 [com.wsscode/pathom "2.2.28"]])
