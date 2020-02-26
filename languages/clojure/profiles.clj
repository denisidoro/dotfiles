{:user

 {:min-lein-version
  "2.9.0"

  :repositories
  [["central"  {:url "https://repo1.maven.org/maven2/" :snapshots false}]
   ["clojars"  {:url "https://clojars.org/repo/"}]
   ["nu-maven" {:url "s3p://nu-maven/releases/" :region "sa-east-1"}]]

  :plugin-repositories
  [["nu-maven" {:url "s3p://nu-maven/releases/"}]]

  :plugins
  [[s3-wagon-private "1.3.2" :exclusions [commons-logging org.apache.httpcomponents/httpclient]]
   [lein-ancient "0.6.15"]]

  :jvm-opts
  ["-Duser.language=en"
   "-Duser.region=US"
   "-Xverify:none"]

  :dependencies
  [[cljdev "0.9.0" :exclusions [org.clojure/clojure]]
    [spieden/spyscope "0.1.7-SNAPSHOT" :exclusions [org.clojure/clojure]]]

  :injections
  [(require 'nu)
   (require 'spyscope.core)]

  :global-vars
  {*warn-on-reflection* false}}}
