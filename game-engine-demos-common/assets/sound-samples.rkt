#lang racket

(provide DUCK-SOUND
         CAT-SOUND
         DOG-SOUND
         HEY-SOUND
         ZOOP-SOUND)

(require rsound
         racket/runtime-path)

(define-runtime-path duck-path "duck.wav")
(define-runtime-path cat-path "meow2.wav")
(define-runtime-path dog-path "dog2.wav")
(define-runtime-path hey-path "hey.wav")
(define-runtime-path zoop-path "zoop.wav")

(define DUCK-SOUND (resample-to-rate 48000 (rs-read duck-path)))
(define CAT-SOUND  (resample-to-rate 48000 (rs-read cat-path)))
(define DOG-SOUND  (resample-to-rate 48000 (rs-read dog-path)))
(define HEY-SOUND  (resample-to-rate 48000 (rs-read hey-path)))
(define ZOOP-SOUND (resample-to-rate 48000 (rs-read zoop-path)))

