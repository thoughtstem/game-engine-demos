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
         CLOSE-DIALOG-SOUND)

(require #;(only-in rsound
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

(define DUCK-SOUND '() #;(resample-to-rate 48000 (rs-read duck-path)))
(define CAT-SOUND  '() #;(resample-to-rate 48000 (rs-read cat-path)))
(define DOG-SOUND  '() #;(resample-to-rate 48000 (rs-read dog-path)))
(define HEY-SOUND  '() #;(resample-to-rate 48000 (rs-read hey-path)))
(define ZOOP-SOUND '() #;(resample-to-rate 48000 (rs-read zoop-path)))

(define PICKUP-SOUND       '() #;(resample-to-rate 48000 (rs-read pickup-path)))
(define BLIP-SOUND         '() #;(resample-to-rate 48000 (rs-read blip-path)))
(define SHORT-BLIP-SOUND   '() #;(resample-to-rate 48000 (rs-read short-blip-path)))
(define OPEN-DIALOG-SOUND  '() #;(resample-to-rate 48000 (rs-read open-dialog-path)))
(define CLOSE-DIALOG-SOUND '() #;(resample-to-rate 48000 (rs-read close-dialog-path)))

