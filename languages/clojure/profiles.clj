{:user

 {:dependencies
  [[cljdev "0.8.0" :exclusions [org.clojure/clojure]]
   ;[org.clojure/tools.trace "0.7.10" :exclusions [org.clojure/clojure]]
   ;[spyscope "0.1.7-SNAPSHOT" :exclusions [org.clojure/clojure]]
   ]

  :jvm-opts
  ["-Duser.language=en"
   "-Duser.region=US"
   "-Xverify:none"]

  :injections
  [(require 'nu)
   ;(require '[spyscope.core :as spy])
   ]

  :repositories
  [["nu-maven" {:url        "s3p://nu-maven/releases/"
                :username   [:gpg :env/artifacts_aws_access_key_id]
                :passphrase [:gpg :env/artifacts_aws_secret_access_key]}]]

  :plugins
  [[s3-wagon-private "1.3.1" :exclusions [commons-logging]]]}

 :repl

 {:plugins
  [
   ;[cider/cider-nrepl "0.21.0"]
   ;[refactor-nrepl "2.4.1-SNAPSHOT"]
   ]

  :dependencies
  [
   ;[org.clojure/tools.nrepl "0.2.13"]
   ]

  :repl-options
  {:timeout 180000}

  :global-vars
  {*warn-on-reflection* false}}}
