#lang racket

(provide badge-image)

(require racket/runtime-path)
(require 2htdp/image)

(define-runtime-path package-path "badge.png")

(define (badge-image level)
   (define level-text (text (number->string level) 24 "black"))
   (overlay level-text (bitmap/file  package-path)))
