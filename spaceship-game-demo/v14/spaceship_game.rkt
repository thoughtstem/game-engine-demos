#lang racket

(require game-engine
         game-engine-demos-common)

(define WIDTH  640)
(define HEIGHT 480)

(define bg-entity
  (sprite->entity (space-bg-sprite WIDTH HEIGHT 100)
                  #:name     "bg"
                  #:position (posn 0 0)
                  #:components (static)))

(define (spaceship-entity)
  (sprite->entity spaceship-sprite
                  #:name       "ship"
                  #:position   (posn 100 100)
                  #:components (key-movement 5)
                               (on-collide "ore"    (change-speed-by 1))
                               (on-collide "enemy"  die)
                               (on-collide "bullet" die)))

(define (ore-entity p)
  (sprite->entity (ore-sprite (random 10))
                  #:position   p
                  #:name       "ore"
                  #:components (on-collide "ship" (randomly-relocate-me 0 WIDTH 0 HEIGHT))))

(define (enemy-entity p)
  (sprite->entity (spaceship-animator 'left)
                  #:position    p
                  #:name        "enemy"
                  #:components  (every-tick (move-up-and-down #:min   0
                                                              #:max   HEIGHT
                                                              #:speed 10))
                                (do-every 20 (spawn bullet))))

(define bullet2
  (sprite->entity (new-sprite (list (circle 2 "solid" "red")
                                    (circle 2 "solid" "orange")
                                    (circle 2 "solid" "yellow")
                                    (circle 2 "solid" "orange")) 1)
                  #:position   (posn -16 0)
                  #:name       "bullet"
                  #:components (every-tick (move-left #:speed 10))
                               (after-time 20     die)
                               (on-collide "ship" die)))

(define bullet
  (sprite->entity (sprite-map (lambda (i)
                                (scale 0.35 i)) (spaceship-animator 'left))
                  #:position   (posn 0 0)
                  #:name       "bullet"
                  #:components (every-tick (move-left #:speed 5))
                               (after-time 75     die)
                               (on-collide "ship" die)
                               (spawner bullet2 30)))

(define (lost? g e)
  (not (get-entity "ship" g)))

(define (won? g e)
  (define speed (get-speed (get-entity "ship" g)))
  (>= speed 10))

(start-game (instructions WIDTH HEIGHT "Use arrow keys to move")
            (game-over-screen won? lost?)
            (spaceship-entity)
            (ore-entity (posn 400 400))
            (enemy-entity (posn 500 300))
            bg-entity)
