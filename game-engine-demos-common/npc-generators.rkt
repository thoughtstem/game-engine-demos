#lang racket

(provide create-npc
         update-dialog
         quest
         quest-reward
         
         item-reward-system
         counter-reward-system
         hunt-reward-system
         
         random-npc
         random-character-row
         (rename-out (random-character-row random-npc-row))
         random-character-sprite
         entity-in-game?)

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
                                     (λ (g e)
                                       (add-components e (on-key 'enter (do-many (update-dialog response-dialog)
                                                                                 (do-after-time 1 die)))))
                                     )))
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
         ;((near? "player") g npc) ;removing since player sometimes gets pushed away
         )))

(define (quest-complete-by-id? #:quest-giver npc-name
                               #:quest-item item)
  (lambda (g e)
    (define npc (get-entity npc-name g))
    (define quest-item-in-game? ((in-game-by-id? (get-storage-data "item-id" item)) g e))
    (define npc-dialog (get-entity "npc dialog" g))
    (and quest-item-in-game?
         npc
         npc-dialog
         ;((near? "player") g npc) ;removing since player sometimes gets pushed away
         )))

(define (counter-quest-complete? #:quest-giver-name name
                                 #:collect-amount collect-amount)
  (lambda (g e)
    (define count (get-counter (get-entity "score" g)))
    (define npc (get-entity name g))
    (define npc-dialog (get-entity "npc dialog" g))
    (and npc
         npc-dialog
         (>= count collect-amount)
         ;((near? "player") g npc) ;removing since player sometimes gets pushed away
         )))

(define (hunt-quest-complete? #:quest-giver-name name
                              #:hunt-amount hunt-amount)
  (lambda (g e)
    (define hunt-count (get-storage-data "kill-count" (get-entity "score" g)))
    (define npc (get-entity name g))
    (define npc-dialog (get-entity "npc dialog" g))
    (and npc
         npc-dialog
         (>= hunt-count hunt-amount)
         ;((near? "player") g npc) ;removing since player sometimes gets pushed away
         )))

(define (remove-on-key g e)
  (remove-component e on-key?))

; this must be placed on the score counter entity
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

; ===== REFACTOED REWARD SYSTEM =====
; assume will be attached to quest-giver
(define (item-reward-system #:rule rule
                            #:reward-item reward-item)      ;must be a custom-item to have unique id's
  (define item-id (get-storage-data "item-id" reward-item))

  (define reward-storage-name (~a "item-reward-component-" item-id))
  
  (define (remove-item-reward-component g e)
    (remove-component e (curry component-eq? (get-storage-data reward-storage-name e))))
  
  (define item-reward-component
    (on-key "enter"
           #:rule rule
           (do-many remove-item-reward-component
                    (if reward-item (spawn-on-current-tile reward-item) (λ (g e) e))
                    )))
  
  (list (storage reward-storage-name item-reward-component)
        item-reward-component))

(define (counter-reward-system #:quest-giver-name quest-giver-name
                               #:collect-amount   collect-amount
                               #:reward-amount    reward-amount)
  
  ;Note: quest giver name must be unique to avoid conflicts.
  ;todo: change this to an entity with a uniqie pre-game npc-id
  (define reward-storage-name (~a "counter-reward-component-" quest-giver-name "-" collect-amount))
  
  (define (remove-counter-reward-component g e)
    (~> e
        (remove-component _ (curry component-eq? (get-storage-data reward-storage-name e)))
        (remove-storage reward-storage-name _)))
  
  (define counter-reward-component
    (on-key "enter"
           #:rule (counter-quest-complete? #:quest-giver-name quest-giver-name
                                           #:collect-amount collect-amount)
           (do-many remove-counter-reward-component
                    (change-counter-by (- reward-amount collect-amount)))
           ))
  (list (storage reward-storage-name counter-reward-component)
        counter-reward-component))

(define (hunt-reward-system #:quest-giver-name quest-giver-name
                            #:hunt-amount      hunt-amount
                            #:reward-amount    reward-amount)
  
  ;Note: quest giver name must be unique to avoid conflicts.
  ;todo: change this to an entity with a uniqie pre-game npc-id
  (define reward-storage-name (~a "hunt-reward-component-" quest-giver-name "-" hunt-amount))
  
  (define (remove-hunt-reward-component g e)
    (~> e
        (remove-component _ (curry component-eq? (get-storage-data reward-storage-name e)))
        (remove-storage reward-storage-name _)))
  
  (define hunt-reward-component
    (on-key "enter"
            #:rule (hunt-quest-complete? #:quest-giver-name quest-giver-name
                                         #:hunt-amount hunt-amount)
            (do-many remove-hunt-reward-component
                     (change-counter-by reward-amount))
            ))
  (list (storage reward-storage-name hunt-reward-component)
        hunt-reward-component))

(define (entity-in-game? name)
  (lambda (g e)
    (get-entity name g)))