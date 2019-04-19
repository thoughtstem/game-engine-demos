#lang racket

(require game-engine)

(provide instructions
         make-instructions)

;Speed this up???
(define (screen w h msg color)
  (new-sprite (list (overlay (text msg 30 color)
                             (rectangle w h "solid" (make-color 0 0 0 100))))
              1))

(define (instructions w h msg (color "green"))
  (sprite->entity (screen w h msg color)
                  #:position   (posn (/ w 2)
                                     (/ h 2))
                  #:name       "ui"
                  #:components (static)
                               (after-time 50 die)))

(define/contract (make-instructions . lines)
  (->* () #:rest (listof string?) entity?)
  
  (define i-list lines)
  (define i-length (length i-list))
  (define last-y-pos (* 20 i-length))
  
  (define bg-img (rectangle 1 1 'solid (make-color 0 0 0 100)))
  (precompile! bg-img) ;in case this entity doesn't start with the game
  
  (define (instruction->sprite text offset)
    (new-sprite text #:y-offset offset #:color 'yellow))

  (define instruction-sprites
    (map instruction->sprite i-list (range (- (/ last-y-pos 2)) (add1 (/ last-y-pos 2)) (/ last-y-pos (sub1 i-length)))))
  
  (sprite->entity (list instruction-sprites
                        (new-sprite bg-img
                                    #:x-scale 340
                                    #:y-scale (* 26 i-length)))            
                  #:position   (posn 0 0)
                  #:name       "instructions"
                  #:components (layer "ui")
                               (hidden)
                               (on-start (do-many (go-to-pos 'center)
                                                  show))
                               (on-key 'enter die)
                               (on-key 'space die)
                               (on-key "i" die)))
