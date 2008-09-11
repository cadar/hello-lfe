(define-module myhello
    (export (start 0)))

(define (start)
    (: io format '"Hello World!~n"))