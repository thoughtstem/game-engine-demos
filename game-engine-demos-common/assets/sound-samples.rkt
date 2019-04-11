#lang racket

(provide DUCK-SOUND
         CAT-SOUND
         DOG-SOUND
         HEY-SOUND
         ZOOP-SOUND
         PICKUP-SOUND
         BLIP-SOUND
         SHORT-BLIP-SOUND
         OPEN-DIALOG-SOUND
         CLOSE-DIALOG-SOUND
         EXPLOSION-SOUND BIG-EXPLOSION-SOUND 
         HIT-SOUND
         LASER-SOUND
         SLASH1-SOUND
         SLASH2-SOUND
         SLASH3-SOUND
         SLASH4-SOUND
         WOOSH1-SOUND
         WOOSH2-SOUND
         WOOSH3-SOUND
         WOOSH4-SOUND
         FIRE-MAGIC-SOUND
         ICE-MAGIC-SOUND
         BUBBLE-SOUND
         LIGHTSABER1-SOUND
         LIGHTSABER2-SOUND
         LIGHTSABER3-SOUND
         LIGHTSABER4-SOUND
         BLASTER1-SOUND
         BLASTER2-SOUND
         BLASTER3-SOUND
         BLASTER4-SOUND
         random-slash-sound
         random-woosh-sound
         random-lightsaber-sound
         random-blaster-sound)

(require 
  game-engine/engine/extensions/sound
  racket/runtime-path)

(define-runtime-path duck-path "duck.wav")
(define-runtime-path cat-path "meow2.wav")
(define-runtime-path dog-path "dog2.wav")
(define-runtime-path hey-path "hey.wav")
(define-runtime-path zoop-path "zoop.wav")

(define-runtime-path pickup-path "pickup.wav")
(define-runtime-path blip-path "blip.wav")
(define-runtime-path short-blip-path "short_blip.wav")
(define-runtime-path open-dialog-path "open_dialog.wav")
(define-runtime-path close-dialog-path "close_dialog.wav")

(define-runtime-path explosion-path "explosion.wav")
(define-runtime-path big-explosion-path "big_explosion.wav")
(define-runtime-path hit-path "hit.wav")
(define-runtime-path laser-path "laser.wav")

(define-runtime-path slash1-path "slash1.wav")
(define-runtime-path slash2-path "slash2.wav")
(define-runtime-path slash3-path "slash3.wav")
(define-runtime-path slash4-path "slash4.wav")

(define-runtime-path woosh1-path "woosh1.wav")
(define-runtime-path woosh2-path "woosh2.wav")
(define-runtime-path woosh3-path "woosh3.wav")
(define-runtime-path woosh4-path "woosh4.wav")

(define-runtime-path fire-magic-path "fire_magic.wav")
(define-runtime-path ice-magic-path  "ice_magic.wav")
(define-runtime-path bubble-path  "bubble.wav")

(define-runtime-path lightsaber1-path "lightsaber1.wav")
(define-runtime-path lightsaber2-path "lightsaber2.wav")
(define-runtime-path lightsaber3-path "lightsaber3.wav")
(define-runtime-path lightsaber4-path "lightsaber4.wav")

(define-runtime-path blaster1-path "blaster1.wav")
(define-runtime-path blaster2-path "blaster2.wav")
(define-runtime-path blaster3-path "blaster3.wav")
(define-runtime-path blaster4-path "blaster4.wav")

(define DUCK-SOUND 
  (sound duck-path))

(define CAT-SOUND 
  (sound cat-path) )

(define DOG-SOUND 
  (sound dog-path) )

(define HEY-SOUND 
  (sound hey-path) )

(define ZOOP-SOUND   
  (sound zoop-path) )

(define PICKUP-SOUND  
  (sound pickup-path) )

(define BLIP-SOUND          
  (sound blip-path) )

(define SHORT-BLIP-SOUND  
  (sound short-blip-path) )

(define OPEN-DIALOG-SOUND   
  (sound open-dialog-path) )

(define CLOSE-DIALOG-SOUND  
  (sound close-dialog-path) )

(define EXPLOSION-SOUND  
  (sound explosion-path) )

(define BIG-EXPLOSION-SOUND  
  (sound big-explosion-path) )

(define HIT-SOUND  
  (sound hit-path) )

(define LASER-SOUND  
  (sound laser-path) )

(define SLASH1-SOUND  
  (sound slash1-path) )

(define SLASH2-SOUND  
  (sound slash2-path) )

(define SLASH3-SOUND  
  (sound slash3-path) )

(define SLASH4-SOUND  
  (sound slash4-path) )

(define WOOSH1-SOUND  
  (sound woosh1-path) )

(define WOOSH2-SOUND  
  (sound woosh2-path) )

(define WOOSH3-SOUND  
  (sound woosh3-path) )

(define WOOSH4-SOUND  
  (sound woosh4-path) )

(define FIRE-MAGIC-SOUND  
  (sound fire-magic-path) )

(define ICE-MAGIC-SOUND  
  (sound ice-magic-path) )

(define BUBBLE-SOUND  
  (sound bubble-path) )

(define LIGHTSABER1-SOUND  
  (sound lightsaber1-path) )

(define LIGHTSABER2-SOUND  
  (sound lightsaber2-path) )

(define LIGHTSABER3-SOUND  
  (sound lightsaber3-path) )

(define LIGHTSABER4-SOUND  
  (sound lightsaber4-path) )

(define BLASTER1-SOUND  
  (sound blaster1-path) )

(define BLASTER2-SOUND  
  (sound blaster2-path) )

(define BLASTER3-SOUND  
  (sound blaster3-path) )

(define BLASTER4-SOUND  
  (sound blaster4-path) )

; ==== RANDOM SOUND FUNCTIONS ====
(define (random-slash-sound)
  (first (shuffle (list SLASH1-SOUND
                        SLASH2-SOUND
                        SLASH3-SOUND
                        SLASH4-SOUND))))

(define (random-woosh-sound)
  (first (shuffle (list WOOSH1-SOUND
                        WOOSH2-SOUND
                        WOOSH3-SOUND
                        WOOSH4-SOUND))))

(define (random-lightsaber-sound)
  (first (shuffle (list LIGHTSABER1-SOUND
                        LIGHTSABER2-SOUND
                        LIGHTSABER3-SOUND
                        LIGHTSABER4-SOUND))))

(define (random-blaster-sound)
  (first (shuffle (list BLASTER1-SOUND
                        BLASTER2-SOUND
                        BLASTER3-SOUND
                        BLASTER4-SOUND))))


