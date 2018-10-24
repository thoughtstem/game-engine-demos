#lang racket

(provide create-npc
         update-dialog
         quest
         random-npc)
;(provide sheet->rainbow-tint-sheet)

(require "./assets/sound-samples.rkt"
         "./sith-character-generator.rkt")
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
                    #:sound       [sound #t]
                    #:scale       [scale 1]
                    #:components  [c #f]
                    . cs)
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
                                                   (on-start (scale-sprite scale))
                                                   (cons c cs)))
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
    [(eq? mode 'still)  (add-components dialog-entity
                                        (on-start (stop-animation)))]
    [(eq? mode 'wander) (add-components dialog-entity
                                        (every-tick (move))
                                        (on-key 'enter
                                                #:rule (last-dialog-and-near? "player")
                                                (do-many (set-speed spd)
                                                         (start-animation)))
                                        (do-every 50 (random-direction 0 360))
                                        (on-edge 'left   (set-direction 0))
                                        (on-edge 'right  (set-direction 180))
                                        (on-edge 'top    (set-direction 90))
                                        (on-edge 'bottom (set-direction 270)))]
    [(eq? mode 'pace)   (add-components dialog-entity
                                        (every-tick (move-left-right #:min move-min  #:max move-max))
                                        (on-key 'enter
                                                #:rule (last-dialog-and-near? "player")
                                                (do-many (set-speed spd)
                                                         (start-animation))))]
    [(eq? mode 'follow) (add-components dialog-entity
                                        (every-tick (move))
                                        (on-key 'enter
                                                #:rule (last-dialog-and-near? "player")
                                                (do-many (set-speed spd)
                                                         (start-animation)))
                                        (follow target))]))



; ====== RANDOM NPC ENTITY CREATOR =====
(define (random-npc [p (posn 0 0)]
                    #:name [name (first (shuffle (list "Adrian" "Alex" "Riley"
                                                       "Sydney" "Charlie" "Andy")))]
                    #:tile [tile 0]
                    #:mode [mode 'still]
                    #:game-width [GAME-WIDTH 480]
                    #:components [c #f] . custom-components )
  (create-npc #:sprite (sheet->sprite (sith-character)
                                 #:rows       4
                                 #:columns    4
                                 #:row-number 3
                                 #:speed      3)
              #:name        name
              #:position    p
              #:active-tile tile
              #:dialog      (dialog->sprites (first (shuffle (list (list "Hello.")
                                                                   (list "Hi! Nice to meet you!")
                                                                   (list "Sorry, I don't have time to talk now.")
                                                                   (list "The weather is nice today."))))
                                             #:game-width GAME-WIDTH
                                             #:animated #t
                                             #:speed 4)
              #:mode        mode
              #:components  (cons c custom-components)))

 
(define (update-dialog new-dialog)
  (lambda (g e)
    (define updated-npc
      ((do-many (point-to "player")
                (set-speed 0)
                (stop-animation))
       g (update-entity (create-npc #:sprite      (get-component e animated-sprite?)
                                    #:name        (get-name e)
                                    #:position    (get-component e posn?)
                                    #:active-tile 0
                                    #:dialog      new-dialog
                                    #:mode        'wander)
                        active-on-bg? (get-component e active-on-bg?))))
    ((spawn updated-npc #:relative? #f) g e)))

(define (quest #:rule                   quest-rule?
               #:quest-complete-dialog  complete-dialog
               #:new-response-dialog    [response-dialog #f])
  (if response-dialog
      (list (on-key "x" #:rule quest-rule?
                              (do-many (point-to "player")
                                       (set-speed 0)
                                       (stop-animation)
                                       (next-dialog complete-dialog #:sound SHORT-BLIP-SOUND)
                                       (update-dialog response-dialog)
                                       (do-after-time 1 die))))
      (list (on-key "x" #:rule quest-rule?
                    (do-many (point-to "player")
                             (set-speed 0)
                             (stop-animation)
                             (next-dialog complete-dialog #:sound SHORT-BLIP-SOUND))))))