#lang racket

(provide character
         random-character
         naked-body
         plumed-helmet-hat
         wizard-hat
         armor-clothes
         robe-clothes
         traveler-clothes
         basic-eyes

         heroify
         (struct-out wearing)
         add-wearing
         )

(require 2htdp/image)
(require game-engine)
(require racket/runtime-path)

(define-runtime-path package-path "assets")

(define (i type num)
  (bitmap/file (build-path package-path (format
                                         "~a-~a.png" type num))))


(define naked-body  (i "body" 1))

;HATS
(define plumed-helmet-hat (i "hat" 1))
(define wizard-hat (i "hat" 2))
(define no-hat     (circle 1 "solid" "transparent"))

;CLOTHES
(define armor-clothes (i "clothes" 1))
(define robe-clothes (i "clothes" 2))
(define traveler-clothes (i "clothes" 3))
(define no-clothes     (circle 1 "solid" "transparent"))

;EYES
(define basic-eyes (i "eyes" 1))



(define (character
          #:body    body
          #:hat     (hat (circle 1 "solid" "transparent"))
          #:clothes (clothes (circle 1 "solid" "transparent"))
          #:eyes    (eyes (circle 1 "solid" "transparent")))
  (overlay hat
           clothes
           eyes
           body))

(define (random-character
          #:body    (body (list naked-body))
          #:hat     (hat  (list wizard-hat plumed-helmet-hat no-hat))
          #:clothes (clothes (list armor-clothes robe-clothes traveler-clothes no-clothes))
          #:eyes    (eyes (list basic-eyes)))
  (character
    #:hat     (change-img-hue (random 0 359) (first (shuffle hat)))
    #:body    (change-img-hue (random 0 359) (first (shuffle body)))
    #:clothes (change-img-hue (random 0 359) (first (shuffle clothes)))
    #:eyes    (change-img-hue (random 0 359) (first (shuffle eyes)))))




(define (heroify entity
                 sheet)
  (~> entity
      ((add-wearing sheet) #f _)
      ;(add-component _ (wearing (list sheet)))
      (add-component _ (key-movement 5))
      (add-component _ (on-key 'down  (swap-to-sprite 'down)))
      (add-component _ (on-key 'up    (swap-to-sprite 'up)))
      (add-component _ (on-key 'left  (swap-to-sprite 'left)))
      (add-component _ (on-key 'right (swap-to-sprite 'right)))
      (add-component _ (on-no-key-movement (swap-to-sprite 'stopped)))))

(define (swap-to-sprite dir)
  (lambda (g e)
   ; (displayln e)
    (define w (get-component e wearing?))
    
    (update-entity e
                   animated-sprite?
                   (match dir
                     ('down   (wearing-down w))
                     ('up     (wearing-up w))
                     ('left   (wearing-left w))
                     ('right  (wearing-right w))
                     ('stopped  (wearing-stopped w))))))

(define (add-wearing clothing-item)
  (lambda (g e)

    (define w (get-component e wearing?))
    
    (define new-wearing-items (cons clothing-item
                                    (if w
                                        (wearing-items w)
                                        '())))
    
    (define sheet (if (= 1 (length new-wearing-items))
                      (first new-wearing-items)
                      (apply overlay new-wearing-items)))
    
    (define (hero-sprite row)
      (sheet->sprite sheet
                     #:rows       4
                     #:columns    4
                     #:row-number row
                     #:speed      5))

    (define moving-down-sprite  (hero-sprite 1))
    (define moving-up-sprite    (hero-sprite 4))
    (define moving-left-sprite  (hero-sprite 2))
    (define moving-right-sprite (hero-sprite 3))

    (define stopped-sprite (new-sprite
                            (pick-frame moving-down-sprite 1)))

    (define new-w (wearing new-wearing-items
                                moving-up-sprite
                                moving-down-sprite
                                moving-left-sprite
                                moving-right-sprite
                                stopped-sprite))

    (if w
        (update-entity e wearing? new-w)
        (add-component e new-w))
    ))


(struct wearing (items up down left right stopped) #:transparent)

(define (update-wearing g e c)
   e)

(new-component wearing?
               update-wearing)



