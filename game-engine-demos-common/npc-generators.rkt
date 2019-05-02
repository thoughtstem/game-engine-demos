#lang racket

(provide create-npc
         update-dialog
         quest
         quest-reward
         random-npc
         random-character-row
         (rename-out (random-character-row random-npc-row))
         random-character-sprite)
;(provide sheet->rainbow-tint-sheet)

(require "./assets/sound-samples.rkt"
         "./sith-character-generator.rkt")
(require game-engine)

(define (last-dialog-and-near? name)
  (lambda (g e)
    (and ((near? name) g e)
         (get-entity "npc dialog" g)
         (last-dialog? g e)
         )))

(define (not-last-dialog-and-near? name)
  (lambda (g e)
    (and ((near? name) g e)
         (get-entity "npc dialog" g)
         (not-last-dialog? g e)
         )))


(define (random-character-row)
  (apply beside
         (map fast-image-data
              (vector->list
               (animated-sprite-frames
                (get-component
                 (random-npc)
                 animated-sprite?))))))

(define (random-character-sprite #:delay [d 4])
  (sheet->sprite (sith-character)
                 #:rows 4
                 #:columns 4
                 #:row-number 3
                 #:delay d))
  
; ==== NPC CREATOR ====
(define (create-npc #:sprite sprite
                    #:name        name
                    #:position    position
                    #:active-tile tile
                    #:dialog      dialog
                    #:game-width  [GAME-WIDTH 480]
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
  (define min-entity (sprite->entity sprite
                                     #:name     name
                                     #:position position))
  (define base-entity (add-components min-entity
                                      (precompiler ;dialog
                                                   ;(fast-dialog-lg name (draw-avatar-box min-entity) GAME-WIDTH)
                                       (square 1 'solid 'black)
                                       (square 1 'solid 'white)
                                       (square 1 'solid 'dimgray)
                                       (draw-avatar-box min-entity)
                                                   )
                                      (static)
                                      (physical-collider)
                                      (active-on-bg tile)
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
                        (storage "dialog" dialog)
                        (on-key 'space #:rule (ready-to-speak-and-near? "player")
                                (do-many (point-to "player")
                                         ;(set-counter 0)
                                         (set-speed 0)
                                         (stop-animation)
                                         (next-dialog dialog #:sound SHORT-BLIP-SOUND))))
        (add-components base-with-sound-entity
                        (storage "dialog" dialog)
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
    [(eq? mode 'wander) (add-components dialog-entity (wander-mode-components spd))]
    [(eq? mode 'pace)   (add-components dialog-entity
                                        (every-tick (move-left-right #:min move-min  #:max move-max))
                                        (on-key 'enter
                                                #:rule (last-dialog-and-near? "player")
                                                (do-many (set-speed spd)
                                                         (start-animation))))]
    [(eq? mode 'follow) (add-components dialog-entity
                                        (follow-mode-components target spd))]
    [else dialog-entity]))

(define (wander-mode-components spd)
  (list 
   (every-tick (move))
   (on-key 'enter
           #:rule (last-dialog-and-near? "player")
           (do-many (set-speed spd)
                    (start-animation)))
   (do-every 50 (random-direction 0 360))
   (on-edge 'left   (set-direction 0))
   (on-edge 'right  (set-direction 180))
   (on-edge 'top    (set-direction 90))
   (on-edge 'bottom (set-direction 270))))

(define (follow-mode-components target spd)
  (list (every-tick (move))
        (on-key 'enter
                #:rule (last-dialog-and-near? "player")
                (do-many (set-speed spd)
                         (start-animation)))
        (follow target)))


; ====== RANDOM NPC ENTITY CREATOR =====
(define (random-npc [p (posn 0 0)]
                    #:name       [name (first (shuffle (list "Adrian" "Alex" "Riley"
                                                             "Sydney" "Charlie" "Andy")))]
                    #:tile       [tile 0]
                    #:mode       [mode 'still]
                    #:game-width [GAME-WIDTH 480]
                    #:speed      [spd 2]
                    #:target     [target "player"]
                    #:sound      [sound #t]
                    #:scale      [scale 1]
                    #:components [c #f] . custom-components )
  (define random-dialog
    (dialog->sprites (first (shuffle (list (list "Hello.")
                                           (list "Hi! Nice to meet you!")
                                           (list "Sorry, I don't have time to talk now.")
                                           (list "The weather is nice today."))))
                     #:game-width GAME-WIDTH
                     #:animated #t
                     #:speed 1))
  (create-npc #:sprite (sheet->sprite (sith-character)
                                 #:rows       4
                                 #:columns    4
                                 #:row-number 3
                                 #:speed      3)
              #:name        name
              #:position    p
              #:active-tile tile
              #:dialog      random-dialog
              #:mode        mode
              #:speed       spd
              #:target      target
              #:sound       sound
              #:scale       scale
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

(struct quest-system (name rule complete-dialog response-dialog cutscene))

(define (quest #:rule                   quest-rule?
               #:quest-complete-dialog  complete-dialog
               #:new-response-dialog    [response-dialog #f]
               #:cutscene               [cutscene #f])
  (if response-dialog
      ;(list (on-key "x" #:rule quest-rule?
      (observe-change quest-rule?
                      (if/r quest-rule?
                            (do-many (point-to "player")
                                     (set-speed 0)
                                     (stop-animation)
                                     (next-dialog complete-dialog #:sound SHORT-BLIP-SOUND)
                                     (update-dialog response-dialog)
                                     (do-after-time 1 die))))
      ;(list (on-key "x" #:rule quest-rule?
      (observe-change quest-rule?
                      (if/r quest-rule?
                            (do-many (point-to "player")
                                     (set-speed 0)
                                     (stop-animation)
                                     (next-dialog complete-dialog #:sound SHORT-BLIP-SOUND))))))

(define (quest-complete? #:quest-giver npc-name
                         #:quest-item item-name)
  (lambda (g e)
    (define npc (get-entity npc-name g))
    (define quest-item (get-entity item-name g))
    (define npc-dialog (get-entity "npc dialog" g))
    (and quest-item
         npc
         npc-dialog
         ((near? "player") g npc))))

(define (quest-complete-by-id? #:quest-giver npc-name
                               #:quest-item item)
  (lambda (g e)
    (define npc (get-entity npc-name g))
    (define quest-item-in-game? ((in-game-by-id? (get-storage-data "item-id" item)) g e))
    (define npc-dialog (get-entity "npc dialog" g))
    (and quest-item-in-game?
         npc
         npc-dialog
         ((near? "player") g npc)
         )))

(define (remove-on-key g e)
  (remove-component e on-key?))

(define (quest-reward #:quest-giver npc-name
                      #:quest-item item
                      #:reward amount)
  (define item-id (get-storage-data "item-id" item))
  (define (remove-quest-reward g e)
      (remove-component e (curry component-eq? (get-storage-data (~a "quest-reward-" item-id) e))))
  (define quest-reward-component
    (on-key "enter"
           #:rule (quest-complete-by-id? #:quest-giver npc-name
                                         #:quest-item item)
           (do-many remove-quest-reward
                    (change-counter-by amount)
                    )))
  (list (storage (~a "quest-reward-" item-id) quest-reward-component)
        quest-reward-component))