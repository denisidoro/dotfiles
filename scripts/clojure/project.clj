(defproject dotfiles "0.2.0-SNAPSHOT"
  :description "Personal dotfiles"
  :url "https://github.com/denisidoro/dotfiles"
  :plugins [[lein-tools-deps "0.4.1"]]
  :middleware [lein-tools-deps.plugin/resolve-dependencies-with-deps-edn]
  :lein-tools-deps/config {:config-files [:install :user :project "./deps.edn"]}
  :main dot
  :aot :all
  :min-lein-version "2.0.0"
  :profiles {:uberjar {:aot :all}}
  :jvm-opts ^:replace ["-Xmx1g" "-server"])