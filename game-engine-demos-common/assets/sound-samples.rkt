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
         random-blaster-sound
         )

(require (only-in rsound
                  resample-to-rate
                  rs-read)
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

(define-runtime-path lightsaber1-path "lightsaber1.wav")
(define-runtime-path lightsaber2-path "lightsaber2.wav")
(define-runtime-path lightsaber3-path "lightsaber3.wav")
(define-runtime-path lightsaber4-path "lightsaber4.wav")

(define-runtime-path blaster1-path "blaster1.wav")
(define-runtime-path blaster2-path "blaster2.wav")
(define-runtime-path blaster3-path "blaster3.wav")
(define-runtime-path blaster4-path "blaster4.wav")

(define DUCK-SOUND 
  (resample-to-rate 48000 (rs-read duck-path)))
(define CAT-SOUND 
  (resample-to-rate 48000 (rs-read cat-path)))
(define DOG-SOUND 
  (resample-to-rate 48000 (rs-read dog-path)))
(define HEY-SOUND 
  (resample-to-rate 48000 (rs-read hey-path)))
(define ZOOP-SOUND   
  (resample-to-rate 48000 (rs-read zoop-path)))

(define PICKUP-SOUND  
  (resample-to-rate 48000 (rs-read pickup-path)))
(define BLIP-SOUND          
  (resample-to-rate 48000 (rs-read blip-path)))
(define SHORT-BLIP-SOUND  
  (resample-to-rate 48000 (rs-read short-blip-path)))

(define OPEN-DIALOG-SOUND   
  (resample-to-rate 48000 (rs-read open-dialog-path)))
(define CLOSE-DIALOG-SOUND  
  (resample-to-rate 48000 (rs-read close-dialog-path)))

(define EXPLOSION-SOUND  
  (resample-to-rate 48000 (rs-read explosion-path)))

(define BIG-EXPLOSION-SOUND  
  (resample-to-rate 48000 (rs-read big-explosion-path)))

(define HIT-SOUND  
  (resample-to-rate 48000 (rs-read hit-path)))

(define LASER-SOUND  
  (resample-to-rate 48000 (rs-read laser-path)))

(define SLASH1-SOUND  
  (resample-to-rate 48000 (rs-read slash1-path)))

(define SLASH2-SOUND  
  (resample-to-rate 48000 (rs-read slash2-path)))

(define SLASH3-SOUND  
  (resample-to-rate 48000 (rs-read slash3-path)))

(define SLASH4-SOUND  
  (resample-to-rate 48000 (rs-read slash4-path)))

(define WOOSH1-SOUND  
  (resample-to-rate 48000 (rs-read woosh1-path)))

(define WOOSH2-SOUND  
  (resample-to-rate 48000 (rs-read woosh2-path)))

(define WOOSH3-SOUND  
  (resample-to-rate 48000 (rs-read woosh3-path)))

(define WOOSH4-SOUND  
  (resample-to-rate 48000 (rs-read woosh4-path)))

(define FIRE-MAGIC-SOUND  
  (resample-to-rate 48000 (rs-read fire-magic-path)))

(define ICE-MAGIC-SOUND  
  (resample-to-rate 48000 (rs-read ice-magic-path)))

(define LIGHTSABER1-SOUND  
  (resample-to-rate 48000 (rs-read lightsaber1-path)))

(define LIGHTSABER2-SOUND  
  (resample-to-rate 48000 (rs-read lightsaber2-path)))

(define LIGHTSABER3-SOUND  
  (resample-to-rate 48000 (rs-read lightsaber3-path)))

(define LIGHTSABER4-SOUND  
  (resample-to-rate 48000 (rs-read lightsaber4-path)))

(define BLASTER1-SOUND  
  (resample-to-rate 48000 (rs-read blaster1-path)))

(define BLASTER2-SOUND  
  (resample-to-rate 48000 (rs-read blaster2-path)))

(define BLASTER3-SOUND  
  (resample-to-rate 48000 (rs-read blaster3-path)))

(define BLASTER4-SOUND  
  (resample-to-rate 48000 (rs-read blaster4-path)))

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


