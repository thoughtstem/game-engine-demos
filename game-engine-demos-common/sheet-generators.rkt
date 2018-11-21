#lang racket

(provide sheet->rainbow-hue-sheet)
(provide sheet->rainbow-tint-sheet
         rainbow-sprite)

(require game-engine)

(define (sheet->rainbow-hue-sheet sprite-sheet)
  (above (change-img-hue 30 sprite-sheet)
         (change-img-hue 60 sprite-sheet)
         (change-img-hue 90 sprite-sheet)
         (change-img-hue 120 sprite-sheet)
         (change-img-hue 150 sprite-sheet)
         (change-img-hue 180 sprite-sheet)
         (change-img-hue 210 sprite-sheet)
         (change-img-hue 240 sprite-sheet)
         (change-img-hue 270 sprite-sheet)
         (change-img-hue 300 sprite-sheet)
         (change-img-hue 330 sprite-sheet)
         (change-img-hue 360 sprite-sheet)))

(define (sheet->rainbow-tint-sheet sprite-sheet)
  (above (tint-img (hsb->color (make-color-hsb 30)) sprite-sheet)
         (tint-img (hsb->color (make-color-hsb 60)) sprite-sheet)
         (tint-img (hsb->color (make-color-hsb 90)) sprite-sheet)
         (tint-img (hsb->color (make-color-hsb 120)) sprite-sheet)
         (tint-img (hsb->color (make-color-hsb 150)) sprite-sheet)
         (tint-img (hsb->color (make-color-hsb 180)) sprite-sheet)
         (tint-img (hsb->color (make-color-hsb 210)) sprite-sheet)
         (tint-img (hsb->color (make-color-hsb 240)) sprite-sheet)
         (tint-img (hsb->color (make-color-hsb 270)) sprite-sheet)
         (tint-img (hsb->color (make-color-hsb 300)) sprite-sheet)
         (tint-img (hsb->color (make-color-hsb 330)) sprite-sheet)
         (tint-img (hsb->color (make-color-hsb 360)) sprite-sheet)
         ))


(define (rainbow-sprite i)
  (sheet->sprite (sheet->rainbow-tint-sheet i)
                 #:rows 12
                 #:columns 1
                 #:row-number (add1 (random 12))
                 #:delay 1))

