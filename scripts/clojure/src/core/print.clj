(ns core.print
  (:require [puget.printer :as puget]))

(def color
  puget/cprint)

(def pretty
  puget/pprint)

(def simple
  println)
