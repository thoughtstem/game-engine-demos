#lang racket

(require game-engine)

(provide left-edge)
(provide right-edge)
(provide top-edge)
(provide bottom-edge)
;(provide all-edges)
  
(define (left-edge)
  (sprite->entity (rectangle 2 1000 "solid" "red")
                  #:position (posn 0 0)
                  #:name "left edge"
                  #:components (static)
                               (physical-collider)
                               (on-start (go-to-pos 'left-center))))

(define (right-edge)
  (sprite->entity (rectangle 2 1000 "solid" "red")
                  #:position (posn 0 0)
                  #:name "right edge"
                  #:components (static)
                               (physical-collider)
                               (on-start (go-to-pos 'right-center))))
(define (top-edge)
  (sprite->entity (rectangle 1000 2 "solid" "red")
                  #:position (posn 0 0)
                  #:name "top edge"
                  #:components (static)
                               (physical-collider)
                               (on-start (go-to-pos 'top-center))))
(define (bottom-edge)
  (sprite->entity (rectangle 1000 2 "solid" "red")
                  #:position (posn 0 0)
                  #:name "bottom edge"
                  #:components (static)
                               (physical-collider)
                               (on-start (go-to-pos 'bottom-center))))
