{:user

 {:min-lein-version
  "2.9.0"

  :repositories
  [["central"  {:url "https://repo1.maven.org/maven2/" :snapshots false}]
   ["clojars"  {:url "https://clojars.org/repo/"}]]

  :plugin-repositories
  []

  :plugins
  []

  :jvm-opts
  ["-Duser.language=en"
   "-Duser.region=US"
   "-Xverify:none"]

  :dependencies
  [[spieden/spyscope "0.1.7-SNAPSHOT" :exclusions [org.clojure/clojure]]]

  :injections
  [(require 'spyscope.core)]

  :global-vars
  {*warn-on-reflection* false}}}
