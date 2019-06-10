#lang racket

(provide game-over-screen
         player-dead?)

(require game-engine
         (only-in racket/draw make-font)
         2htdp/image)

(define player-dead?
  (handler g e (not (get-entity "player" g))))

(define title-font (make-font #:size 24 #:face MONOSPACE-FONT-FACE #:family 'modern #:weight 'bold))
(register-fonts! title-font)
(precompile! (square 1 'solid 'red)
             (square 1 'solid 'green))

(define (end-screen w h msg color)
  (append (list (new-sprite (text-frame msg #:font title-font #:color 'black) #:y-offset -8))
          (bordered-box-sprite (* 18 (+ 2 (string-length msg)))
                               48
                               #:color color))
  )



(define lose-screen (lambda (w h) (end-screen w h "GAME OVER!" "red")))
(define win-screen  (lambda (w h) (end-screen w h "YOU WIN!" "green")))

;(define (precompile-game-over g e)
;  (add-components e (precompiler (lose-screen (game-width g) (game-height g))
;                                (win-screen (game-width g) (game-height g)))))

(define (game-over-screen won? lost?)
  
  (sprite->entity empty-image ;(square 1 "solid" (make-color 0 0 0 0))
                  #:position   (posn 0 0)
                  #:name       "Game Over Screen"
                  #:components (hidden)
                               (layer "ui")
                               ;(on-start precompile-game-over)
                               (every-tick (maybe-end won? lost?))))

(define (maybe-end won? lost?)
  (lambda (g e)
    (cond
      [(lost? g e) (show-end-screen g e (lose-screen (game-width g) (game-height g)))]
      [(won? g e)  (show-end-screen g e (win-screen  (game-width g) (game-height g)))]
      [else e])))

(define (show-end-screen g e sprite-list)
  (~> e
      (remove-component _ hidden?)
      (remove-component _ every-tick?)
      (update-entity _ posn? (posn (/ (game-width g) 2)
                                   (/ (game-height g) 2)))
      ;(update-entity _ animated-sprite? sprite)
      (remove-components _ animated-sprite?)
      (add-components _ (reverse sprite-list))

      ))
