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
         EXPLOSION-SOUND 
         BIG-EXPLOSION-SOUND 
         HIT-SOUND
         LASER-SOUND)

(require (only-in rsound
                  resample-to-rate
                  rs-read)
         racket/runtime-path
         memoize)

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

(define/memo (DUCK-SOUND)  (resample-to-rate 48000 (rs-read duck-path)))
(define/memo (CAT-SOUND)   (resample-to-rate 48000 (rs-read cat-path)))
(define/memo (DOG-SOUND)   (resample-to-rate 48000 (rs-read dog-path)))
(define/memo (HEY-SOUND)   (resample-to-rate 48000 (rs-read hey-path)))
(define/memo (ZOOP-SOUND)  (resample-to-rate 48000 (rs-read zoop-path)))

(define/memo (PICKUP-SOUND)       (resample-to-rate 48000 (rs-read pickup-path)))
(define/memo (BLIP-SOUND)         (resample-to-rate 48000 (rs-read blip-path)))
(define/memo (SHORT-BLIP-SOUND)   (resample-to-rate 48000 (rs-read short-blip-path)))
(define/memo (OPEN-DIALOG-SOUND)  (resample-to-rate 48000 (rs-read open-dialog-path)))
(define/memo (CLOSE-DIALOG-SOUND) (resample-to-rate 48000 (rs-read close-dialog-path)))

(define/memo (EXPLOSION-SOUND) (resample-to-rate 48000 (rs-read explosion-path)))
(define/memo BIG-EXPLOSION-SOUND (resample-to-rate 48000 (rs-read big-explosion-path)))
(define/memo (HIT-SOUND) (resample-to-rate 48000 (rs-read hit-path)))
(define/memo (LASER-SOUND) (resample-to-rate 48000 (rs-read laser-path)))


