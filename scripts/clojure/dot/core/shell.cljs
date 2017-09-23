(ns dot.core.shell
  (:refer-clojure :exclude [find sort cat])
  (:require [clojure.string :as str]))

(def ^:private proc (js/require "child_process"))

(defn shell-fn
  "Examples:
  (cmd \"ls\")
  (cmd \"ls\" \".\")
  (cmd \"ls\" \".\" {:env {\"TOKEN\" \"123\"}})
  (cmd \"cat\" previous-cmd-output)
  (cmd \"grep\" previous-cmd-output \"a\")
  (cmd \"ls\" previous-cmd-output \".\" {:env {\"TOKEN\" \"123\"}})"
  ([cmd & args]
   (let [args (if (seq args) args [])
         first-arg (first args)
         last-arg (last args)
         previous-output (when (map? first-arg) first-arg)
         args (if previous-output (drop 1 args) args)
         options (if (and (> (count args) 1) (map? last-arg)) last-arg {})
         args (if (seq options) (drop-last args) args)
         options (if previous-output
                   (merge options {:input (:stdout previous-output)})
                   options)]
     (-> proc
         (.spawnSync cmd (clj->js args) (clj->js options))
         (js->clj :keywordize-keys true)))))

(defn buffer->coll
  [buffer]
  (-> buffer
      str
      (str/split (re-pattern "\n|\t"))))

(defn output->coll
  [output]
  (-> output
      :stdout
      buffer->coll))

(defn output->str
  [output]
  (-> output
      :stdout
      str))

(defn exit
  ([]
   (exit 0))
  ([code]
   (.exit js/process code)))

(defn error
  ([code]
   (exit code))
  ([code msg]
   (.error js/console msg)
   (exit code)))

(def grep (partial shell-fn "grep"))
(def find (partial shell-fn "find"))
(def sed (partial shell-fn "sed"))
(def awk (partial shell-fn "awk"))
(def diff (partial shell-fn "diff"))
(def sort (partial shell-fn "sort"))
(def export (partial shell-fn "export"))
(def xargs (partial shell-fn "xargs"))
(def ls (partial shell-fn "ls"))
(def pwd (partial shell-fn "pwd"))
(def cd (partial shell-fn "cd"))
(def ps (partial shell-fn "ps"))
(def df (partial shell-fn "df"))
(def kill (partial shell-fn "kill"))
(def rm (partial shell-fn "rm"))
(def cp (partial shell-fn "cp"))
(def mv (partial shell-fn "mv"))
(def cat (partial shell-fn "cat"))
(def chmod (partial shell-fn "chmod"))
(def chown (partial shell-fn "chown"))
(def mkdir (partial shell-fn "mkdir"))
(def ifconfig (partial shell-fn "ifconfig"))
(def uname (partial shell-fn "uname"))
(def whereis (partial shell-fn "whereis"))
(def which (partial shell-fn "which"))
(def whatis (partial shell-fn "whatis"))
(def locate (partial shell-fn "locate"))
(def tail (partial shell-fn "tail"))
(def head (partial shell-fn "head"))
(def less (partial shell-fn "less"))
(def ping (partial shell-fn "ping"))
(def date (partial shell-fn "date"))
(def wget (partial shell-fn "wget"))
(def curl (partial shell-fn "curl"))
(def env (partial shell-fn "env"))
