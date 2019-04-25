(ns core.ansi)

(def reset
  "\033[0;00m")

(def clreol
  "\033[K")

(defn color
  [code [r g b]]
  (str "\033[" code ";2;" r ";" g ";" b ";m"))

(def foreground
  (partial color 38))

(def background
  (partial color 48))

(defn colored
  [x]
  (str (foreground [120 120 120])
       (background [60 30 220])
       " "
       x
       clreol
       reset))
