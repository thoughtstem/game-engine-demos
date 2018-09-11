#lang racket

(provide create-npc)
;(provide sheet->rainbow-tint-sheet)

(require "./assets/sound-samples.rkt")
(require game-engine)

(define (last-dialog-and-near? name)
  (lambda (g e)
    (and ((near-entity? name) g e)
         (get-entity "npc dialog" g)
         (last-dialog? g e)
         )))

(define (not-last-dialog-and-near? name)
  (lambda (g e)
    (and ((near-entity? name) g e)
         (get-entity "npc dialog" g)
         (not-last-dialog? g e)
         )))
  
; ==== NPC CREATOR ====
(define (create-npc #:sprite sprite
                    #:name        name
                    #:position    position
                    #:active-tile tile
                    #:dialog      dialog
                    #:mode        [mode 'still]
                    #:speed       [spd 2]
                    #:target      [target "player"]
                    #:sound       [sound #t])
  (define simple-dialog? (animated-sprite? (first dialog)))
  (define move-min (- (posn-x position) 50))
  (define move-max (+ (posn-x position) 50))
  (define base-entity (sprite->entity sprite
                                      #:name       name
                                      #:position   position
                                      #:components (static)
                                                   (physical-collider)
                                                   (active-on-bg tile)
                                                   ;(sound-stream)
                                                   (speed spd)
                                                   (direction 0)
                                                   (rotation-style 'left-right)
                                                   (counter 0)
                                                   (stop-on-edge)
                                                   (on-key 'enter
                                                           #:rule (last-dialog-and-near? "player")  ;(npc-spoke-and-near? "player")
                                                           (do-many ;(set-counter 0)
                                                                    (set-speed spd)
                                                                    (start-animation)))))
  (define base-with-sound-entity
    (if sound
        (add-component base-entity (sound-stream))
        base-entity))
  
  (define dialog-entity
    (if simple-dialog?
        (add-components base-with-sound-entity
                        (on-key 'space #:rule (ready-to-speak-and-near? "player")
                                (do-many (point-to "player")
                                         ;(set-counter 0)
                                         (set-speed 0)
                                         (stop-animation)
                                         (next-dialog dialog #:sound SHORT-BLIP-SOUND))))
        (add-components base-with-sound-entity
                        (on-rule (player-spoke-and-near? "player") (do-many (set-speed 0)
                                                                            (stop-animation)
                                                                            (point-to "player")))
                        (on-key 'enter
                                #:rule (player-spoke-and-near? "player")
                                (do-many ;(set-counter 0)
                                         (next-response dialog #:sound SHORT-BLIP-SOUND)
                                         (play-sound OPEN-DIALOG-SOUND))))))
  (cond
    [(eq? mode 'still)  dialog-entity]
    [(eq? mode 'wander) (add-components dialog-entity
                                        (every-tick (move))
                                        (do-every 50 (random-direction 0 360))
                                        (on-edge 'left   (set-direction 0))
                                        (on-edge 'right  (set-direction 180))
                                        (on-edge 'top    (set-direction 90))
                                        (on-edge 'bottom (set-direction 270)))]
    [(eq? mode 'pace)   (add-components dialog-entity
                                        (every-tick (move-left-right #:min move-min  #:max move-max)))]
    [(eq? mode 'follow) (add-components dialog-entity
                                        (every-tick (move))
                                        (follow target))]))