#lang racket

(provide space-bg-sprite
         make-star-bg)

(require game-engine
         (only-in lang/posn make-posn))

(define (space-bg-sprite w h n)
  (define ps (map list (map (thunk* (random w)) (range n))
                       (map (thunk* (random h)) (range n))
                       (map (thunk* (/ (random 1 75) 100)) (range n))))
  (new-sprite
   (list (stars w h ps)
         (stars w h ps)
         (stars w h ps))
   10))

(define (stars w h ps)
  (if (empty? ps)
      (rectangle w h "solid" "black")
      (place-image
       (rotate
        (random 45)
        (scale (third (first ps))
               (freeze (overlay (circle 2 "solid" (make-color 255 255 255 (random 120 245)))
                                (circle 3 "solid" (make-color 128 128 128 (random 75 100)))))))
       (first (first ps)) (second (first ps))
       (stars w h (rest ps)))))


(define (make-star-bg)
  (define W 480)
  (define H 360)
  (define white-star-img
    (freeze (overlay (circle 2 'solid 'white)
                     (circle 3 'solid (color 255 255 255 100)))))
   (define dark-star-img
    (freeze (overlay (circle 2 'solid 'dimgray)
                     (circle 3 'solid (color 100 100 100 100)))))
  (define (random-star-img num)
    (scale (/ (random 1 75) 100) (first (shuffle (list white-star-img dark-star-img)))))

  (define (random-star-posn num)
    (make-posn (random W)
               (random H)))
               
  (define star-images (map random-star-img (range 100)))
  (define star-posns (map random-star-posn (range 100)))
  (define star-bg-img (place-images star-images
                                    star-posns
                                    (rectangle W H 'solid 'black)))
  (new-sprite star-bg-img))
