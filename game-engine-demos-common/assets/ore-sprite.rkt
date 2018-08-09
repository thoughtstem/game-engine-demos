#lang racket

(provide ore-sprite)

(require game-engine)

(define ore-sheet (bitmap "powerups.png"))
(define (ore-sprite i)
  (sheet->sprite ore-sheet
                 #:rows        20
                 #:columns     8
                 #:row-number  (+ 1 i)
                 #:speed       1))
