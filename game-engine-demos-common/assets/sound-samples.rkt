#lang racket

(provide DUCK-SOUND
         CAT-SOUND
         DOG-SOUND
         HEY-SOUND
         ZOOP-SOUND)

(require rsound)

(define DUCK-SOUND (resample-to-rate 48000 (rs-read (string->path "duck.wav"))))
(define CAT-SOUND  (resample-to-rate 48000 (rs-read (string->path "meow2.wav"))))
(define DOG-SOUND  (resample-to-rate 48000 (rs-read (string->path "dog2.wav"))))
(define HEY-SOUND  (resample-to-rate 48000 (rs-read (string->path "hey.wav"))))
(define ZOOP-SOUND (resample-to-rate 48000 (rs-read (string->path "zoop.wav"))))

