(defmodule hello
  (export (start 0)))

(defun start ()
  (: io format '"Hello World!~n"))