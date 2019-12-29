(defproject dotfiles "0.1.0-SNAPSHOT"
  :description "Tasker Clojurescript wrapper"

  :dependencies [[org.clojure/clojure "1.10.1" :scope "provided"]
                 [org.clojure/clojurescript "1.10.597" :scope "provided"]
                 [denisidoro/quark "0.9.1"]
                 [com.wsscode/pathom "2.2.28"]]
 :clojurescript? true
  :url "http://example.com/FIXME"
  :jvm-opts ^:replace ["-Xmx1g" "-server"]
  :plugins [[lein-cljsbuild "1.1.6"]
             [macchiato/lein-npm "0.6.7"]]
  :source-paths ["src" "target/classes"]
  :clean-targets ["out" "release"]
  :target-path "target"
  :main memento.core
  :npm {:write-package-json true
        :name "@denisidoro/dotfiles"
        :private false
        :dependencies [[sqlite3 "4.1.1"]
                       [source-map-support "0.4.0"]]}

  )