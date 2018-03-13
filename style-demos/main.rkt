#lang racket

(require racket/pretty)
(require (for-syntax racket/syntax wxme))
(require wxme)

(provide play-style
         edit-style)

(define-syntax (play-style stx)
    (syntax-case stx ()
      [(_ x)
       (with-syntax (;[path (format "./v~a/spaceship-game.rkt" (syntax->datum #'x))]
                     [prefix-id (format-id stx "style-demos/style_demo_~a" (syntax->datum #'x))])
           #`(begin
               ;(provide (rename-out [start prefix-id]))
               (require prefix-id)))
      ]))


(define (edit-style n)
  (define rmp
    (module-path-index-resolve

     (module-path-index-join
      (string->symbol (format "style-demos/style_demo_~a" n))
      #f)))
  
  (define path (path->string (resolved-module-path-name rmp)))
  (define dest-file (string-append
                     (path->string
                      (current-directory))
                     (format "style_demo_~a.rkt" n)))
  
  (copy-file path
             dest-file
             #t)

  (system (string-append "open " dest-file))

  ;Ugly way, don't like...
  #;(define content
    (read
     (wxme-port->port
      (open-input-string
       (file->string path)))))
  
  #;(pretty-print
    content
     (current-output-port)
     1)

  )

