#lang racket
; Resources: https://github.com/jrconway3/Universal-LPC-spritesheet

(provide basic-character
         random-universal-lpc-character)

(require 2htdp/image)
(require game-engine)
(require racket/runtime-path)
(define-runtime-path package-path "assets")

; generate basic character: body + eyes + top + bottom + shoes
(define (basic-character gender)
  (define dir (list "shoes" "bottoms" "tops" "eyes" "body"))
  (define dir-path-list (map (lambda (s)
                               (build-path  package-path
                                            "Universal-LPC-spritesheets"
                                            gender
                                            s))
                        dir))
  
  (define body-parts-names (map (lambda (path)
                                  (first (shuffle (directory-list path))))
                                dir-path-list))

  (define body-parts-path (map (lambda (s1 s2)
                                 (build-path s1 s2))
                               dir-path-list body-parts-names))

  (define body-parts-images (map bitmap/file body-parts-path))
  (apply overlay body-parts-images))

; accessorize basic character, add: head-or-hat + belts + arms + random
(define (accessorised-character character gender)
  (define head-or-hair (if (> (modulo (current-seconds) 3) 0) "head" "hats"))
  (define dir (append (list "random" "arms" "belts") (list head-or-hair)))

  (define dir-path-list (map (lambda (s)
                               (build-path package-path
                                           "Universal-LPC-spritesheets"
                                           gender
                                           s))
                        dir))
  
  (define body-parts-names (map (lambda (path)
                                  (first (shuffle (directory-list path))))
                                dir-path-list))

  (define body-parts-path (map (lambda (s1 s2)
                                 (build-path s1 s2))
                               dir-path-list body-parts-names))

  (define body-parts-images (map bitmap/file body-parts-path))
  
  (define acessorised-character (overlay (apply overlay (list-tail body-parts-images 1)) character))
  
  ; adds "rare" random feature to the caracter
  (if (eq? (modulo (current-seconds) 5) 0) (overlay  (first body-parts-images) acessorised-character)
                                           acessorised-character))

; get random-unifersal-lpc-character spritesheet, cut and reorder
(define (random-universal-lpc-character #:gender [gender "r"])
  ;if current seconds is even produce female sprite, male otherwise
  (define gender-dir (cond
                       [(eq? gender "m") "male"]
                       [(eq? gender "f") "female"]
                       [(eq? gender "r") (if (even? (current-seconds)) "female" "male")]))
  (displayln (~a "Gender: " gender-dir))
  (define spritesheet-full (accessorised-character (basic-character gender-dir) gender-dir))

  ; universal lps character spritesheet rows, columns, row-number, columns-off
  (define r     21)
  (define c     13)
  (define n     9)
  (define r-on  4)
  (define c-off 4)

  ;converts to one row facing right
  #;(~> spritesheet-full
      (sheet->costume-list _ c r (* r c))
      (drop _ (* (- n 1) c))
      (take _ (- c c-off)))

  ;drop c-off number of rightmost col
  (define spritesheet-c-off
    (apply beside (~> spritesheet-full
                    (sheet->costume-list _ c 1 (* 1 c))
                    (take _ (- c c-off)))))
  
  ;take r-on rows of frames, get list of rows
  (define s-list (~> spritesheet-c-off
                   (sheet->costume-list _ 1 r (* r 1))
                   (drop _ (* (- n 1) 1))
                   (take _ r-on )))

  ;rearrange rows as front/left/right/back
  (above (list-ref s-list 2)
         (list-ref s-list 1)
         (list-ref s-list 3)
         (list-ref s-list 0))
  )



