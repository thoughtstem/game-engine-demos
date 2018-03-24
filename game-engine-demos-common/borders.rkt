#lang racket

(require game-engine)

(provide left-edge)
(provide right-edge)
(provide top-edge)
(provide bottom-edge)

(define WIDTH 640)
(define HEIGHT 480)

(define (left-edge)
  (sprite->entity (rectangle 1 1000 "solid" "red")
                  #:position (posn 1 (/ HEIGHT 2))
                  #:name "left edge"
                  #:components (static)
                               (physical-collider)))

(define (right-edge)
  (sprite->entity (rectangle 1 1000 "solid" "red")
                  #:position (posn WIDTH (/ HEIGHT 2))
                  #:name "right edge"
                  #:components (static)
                               (physical-collider)))
(define (top-edge)
  (sprite->entity (rectangle 1000 1 "solid" "red")
                  #:position (posn (/ WIDTH 2) 1)
                  #:name "top edge"
                  #:components (static)
                               (physical-collider)))
(define (bottom-edge)
  (sprite->entity (rectangle 1000 1 "solid" "red")
                  #:position (posn (/ WIDTH 2) HEIGHT)
                  #:name "bottom edge"
                  #:components (static)
                               (physical-collider)))