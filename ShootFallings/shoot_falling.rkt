;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname |shoot falling objects|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/image)
(require 2htdp/universe)

;; MISC
(define RAND-X-LIMIT 490)
(define TRUE #true)
(define FALSE #false)
(define X-AXIS-ADJUSTMENT 20)
(define LIST-A (list 1 2 3))
(define LIST-B (list 5 7 8))
(define LIST-C (list 1 2 3 5 7 8))

;; DIRECTION
(define LEFT 'left)
(define RIGHT 'right)

;; KEYSTROKES
(define LEFT-ARROW "left")
(define RIGHT-ARROW "right")
(define SPACE " ")

;; OPERATORS
(define OP-LEFT -)
(define OP-RIGHT +)
(define OP-UP -)
(define OP-DOWN +)

;; SCENE
(define SCENE-WIDTH 500)
(define SCENE-HEIGHT 500)
(define BACKGROUND (empty-scene SCENE-WIDTH SCENE-HEIGHT))

;; HEALTH
(define HEALTH-TEXT "Health : ")
(define HEALTH-FONT-COLOR 'black)
(define HEALTH-FONT-SIZE 24)
(define HEALTH-X 250)
(define HEALTH-Y 30)

;; DEFENDER
(define DEF-WIDTH 40)
(define DEF-HEIGHT 10)
(define DEF-HALF-WIDTH (/ 40 2))
(define DEF-HALF-HEIGHT (/ 10 2))
(define DEF-X 250)
(define DEF-Y 480)
(define DEF-LEFT-EDGE-X (+ 0 DEF-HALF-WIDTH))
(define DEF-RIGHT-EDGE-X (- SCENE-WIDTH DEF-HALF-WIDTH))
(define DEF-SPEED 10)
(define DEFENDER-IMAGE (rectangle DEF-WIDTH DEF-HEIGHT 'solid 'black))

;; DEFENDER LOCATIONS
(define DEF-INIT-LOC (make-posn DEF-X DEF-Y))
(define DEF-INIT-MOV-LEFT (make-posn (- DEF-X DEF-SPEED) DEF-Y))
(define DEF-INIT-MOV-RIGHT (make-posn (+ DEF-X DEF-SPEED) DEF-Y))
(define DEF-LEFT-OVF-LOC (make-posn 8 DEF-Y))
(define DEF-RIGHT-OVF-LOC (make-posn 492 DEF-Y))
(define DEF-LEFT-ALIGN-LOC (make-posn DEF-LEFT-EDGE-X DEF-Y))
(define DEF-RIGHT-ALIGN-LOC (make-posn DEF-RIGHT-EDGE-X DEF-Y))

;; BULLET
(define BULLET-SPEED 10)
(define BULLET-RADIUS 2)
(define BULLET-IMAGE (circle BULLET-RADIUS 'solid 'black))

;; MISSILE
(define MISSILE-SPEED 5)
(define MISSILE-RADIUS 10)
(define MISSILE-IMAGE (circle MISSILE-RADIUS 'solid 'red))

(define MISSILE-LIMIT 10)
(define MAX-MIS-PER-TICK 5)

(define MISSILE-SPAWN-Y-A -15)
(define MISSILE-SPAWN-Y-B -5)

;;-------------------------------DATA-EXAMPLES--------------------------------;;

;; HEALTH
(define HEALTH-INIT 5)
(define HEALTH-REDUCED 4)
(define HEALTH-OVER 0)

;; BULLETS
(define LOF-BULLETS-ST1
  (list (make-posn 100 450) (make-posn 150 420) (make-posn 200 440)
        (make-posn 250 380) (make-posn 300 350) (make-posn 400 430)))
(define LOB-IMAGES
  (list BULLET-IMAGE BULLET-IMAGE BULLET-IMAGE
        BULLET-IMAGE BULLET-IMAGE BULLET-IMAGE))

(define LOB-FIRE-INIT
  (list DEF-INIT-LOC))
(define LOF-BULLETS-ST1-MOVED
  (list (make-posn 100 (OP-UP 450 BULLET-SPEED))
        (make-posn 150 (OP-UP 420 BULLET-SPEED))
        (make-posn 200 (OP-UP 440 BULLET-SPEED))
        (make-posn 250 (OP-UP 380 BULLET-SPEED))
        (make-posn 300 (OP-UP 350 BULLET-SPEED))
        (make-posn 400 (OP-UP 430 BULLET-SPEED))))

(define LOF-BULLETS-FT
  (list (make-posn 100 450) (make-posn 150 420) (make-posn 200 -3)
        (make-posn 250 380) (make-posn 320 261) (make-posn 400 415)))
(define LOF-BULLETS-FILTERED
  (list (make-posn 100 450) (make-posn 150 420) (make-posn 200 -3)
        (make-posn 250 380)))
(define LOF-BULLETS-OOB-FILTERED
  (list (make-posn 100 450) (make-posn 150 420)
        (make-posn 250 380) (make-posn 320 261) (make-posn 400 415)))

(define LOF-BULLETS-ANIM-INIT
  (list (make-posn 100 450) (make-posn 150 420) (make-posn 200 -3)
        (make-posn 250 380) (make-posn 320 261) (make-posn 400 115)))
(define LOF-BULLETS-ANIM-END
  (list (make-posn 100 (OP-UP 450 BULLET-SPEED))
        (make-posn 150 (OP-UP 420 BULLET-SPEED))
        (make-posn 250 (OP-UP 380 BULLET-SPEED))
        (make-posn 400 (OP-UP 115 BULLET-SPEED))))


;; MISSILES
(define LOF-MISSILES-ST1
  (list (make-posn 130 150) (make-posn 166 120) (make-posn 200 240)
        (make-posn 255 280) (make-posn 320 250) (make-posn 400 415)))
(define LOM-IMAGES
  (list MISSILE-IMAGE MISSILE-IMAGE MISSILE-IMAGE
        MISSILE-IMAGE MISSILE-IMAGE MISSILE-IMAGE))

(define LOF-MISSILES-ST1-MOVED
  (list (make-posn 130 (OP-DOWN 150 MISSILE-SPEED))
        (make-posn 166 (OP-DOWN 120 MISSILE-SPEED))
        (make-posn 200 (OP-DOWN 240 MISSILE-SPEED))
        (make-posn 255 (OP-DOWN 280 MISSILE-SPEED))
        (make-posn 320 (OP-DOWN 250 MISSILE-SPEED))
        (make-posn 400 (OP-DOWN 415 MISSILE-SPEED))))

(define LOF-MISSILES-FULL
  (list (make-posn 130 150) (make-posn 166 120) (make-posn 200 240)
        (make-posn 255 280) (make-posn 320 250) (make-posn 400 415)
        (make-posn 230 150) (make-posn 266 120) (make-posn 300 240)
        (make-posn 355 280)))

(define LOF-MISSILES-FT
  (list (make-posn 130 150) (make-posn 166 120) (make-posn 200 520)
        (make-posn 255 280) (make-posn 320 250) (make-posn 400 410)))
(define LOF-MISSILES-FILTERED
  (list (make-posn 130 150) (make-posn 166 120) (make-posn 200 520)
        (make-posn 255 280)))
(define LOF-MISSILES-OOB-FILTERED
  (list (make-posn 130 150) (make-posn 166 120)
        (make-posn 255 280) (make-posn 320 250) (make-posn 400 410)))

(define LOF-MISSILES-ANIM-INIT
  (list (make-posn 130 150) (make-posn 166 120) (make-posn 200 240)
        (make-posn 255 280) (make-posn 320 250) (make-posn 400 415)
        (make-posn 230 150) (make-posn 266 120) (make-posn 200 520)
        (make-posn 355 280) (make-posn 355 285)))
(define LOF-MISSILES-ANIM-END
  (list (make-posn 130 (OP-DOWN 150 MISSILE-SPEED))
        (make-posn 166 (OP-DOWN 120 MISSILE-SPEED))
        (make-posn 200 (OP-DOWN 240 MISSILE-SPEED))
        (make-posn 255 (OP-DOWN 280 MISSILE-SPEED))
        (make-posn 400 (OP-DOWN 415 MISSILE-SPEED))
        (make-posn 230 (OP-DOWN 150 MISSILE-SPEED))
        (make-posn 266 (OP-DOWN 120 MISSILE-SPEED)) 
        (make-posn 355 (OP-DOWN 280 MISSILE-SPEED))
        (make-posn 355 (OP-DOWN 285 MISSILE-SPEED))))

;;------------------------------IMAGE-CONSTANTS-------------------------------;;

(define DEFENDER-INIT-IMAGE (place-image DEFENDER-IMAGE
                                         DEF-X
                                         DEF-Y
                                         BACKGROUND))


(define HEALTH-INIT-TEXT-IMG
  (text (string-append HEALTH-TEXT "5") HEALTH-FONT-SIZE HEALTH-FONT-COLOR))
(define HEALTH-INIT-IMAGE
  (place-image HEALTH-INIT-TEXT-IMG
               HEALTH-X
               HEALTH-Y
               DEFENDER-INIT-IMAGE))

(define LOF-BULLETS-ST1-IMAGE
  (place-images LOB-IMAGES LOF-BULLETS-ST1 HEALTH-INIT-IMAGE))

(define LOF-MISSILES-ST1-IMAGE
  (place-images LOM-IMAGES LOF-MISSILES-ST1 LOF-BULLETS-ST1-IMAGE))

(define WORLD-DRAW-IMAGE LOF-MISSILES-ST1-IMAGE)


;;------------------------------DATA-DEFINITIONS------------------------------;;

;; A Missile is a Posn
;; INTERP: represents the location of a missile

;; A Bullet is a Posn 
;; INTERP: represents the location of a bullet

;; A Location is a Posn 
;; INTERP: represents a location of the defender

;; A Health is a Integer
;; INTERP: represents the number of lives left for the defender.

;; A KeyEvent is a String
;; INTERP: represents the different key-events generated
;;         by input on the keyboard

;; A Direction is one of: 
;; - LEFT
;; - RIGHT
;; INTERP: represent the direction of movement for the defender

;;; Template:
;; direction-fn : Direction -> ???
#; (define (direction-fn d)
     (cond
       [(symbol=? d LEFT) ...]
       [(symbol=? d RIGHT) ...]))

(define-struct defender (dir loc))
;; A Defender is a (make-defender Location Direction)
;; INTERP: represents the defender with its current location and direction
;;         of movement.

;;; Template:
;; defender-fn : Defender -> ???
#; (define (defender-fn a-def)
     ... (direction-fn (defender-dir a-def)) ...
     ... (defender-loc a-def) ...)

;;; Data Examples:
(define DEFENDER-INIT (make-defender LEFT DEF-INIT-LOC))
(define DEFENDER-MOVED (make-defender LEFT DEF-INIT-MOV-LEFT))
(define DEFENDER-DIR-CH (make-defender RIGHT DEF-INIT-LOC))
(define DEFENDER-DIR-CH-MOVED (make-defender RIGHT DEF-INIT-MOV-RIGHT))
(define DEF-LEFT-OVERFLOW (make-defender LEFT DEF-LEFT-OVF-LOC))
(define DEF-RIGHT-OVERFLOW (make-defender RIGHT DEF-RIGHT-OVF-LOC))
(define DEF-LEFT-ALIGN (make-defender LEFT DEF-LEFT-ALIGN-LOC))
(define DEF-RIGHT-ALIGN (make-defender RIGHT DEF-RIGHT-ALIGN-LOC))

(define-struct world (defender missiles bullets health))
;; A World is (make-world Defender Lof[Missile] Lof[Bullet] Health) 
;; INTERP: represent the defender, the current list of missiles and the
;;         list of defender bullets.

;;; Template:
;; world-fn : World -> ???
#; (define (world-fn a-world)
     ... (defender-fn (world-defender a-world)) ...
     ... (world-missiles a-world) ...
     ... (world-bullets a-world) ...
     ... (world-health a-world) ...)

;;; Data Examples:
(define WORLD-INIT (make-world DEFENDER-INIT
                               empty
                               empty
                               HEALTH-INIT))
(define WORLD-INIT-DEF-DIR-UPD (make-world DEFENDER-DIR-CH
                                           empty
                                           empty
                                           HEALTH-INIT))
(define WORLD-INIT-BUL-FIRED (make-world DEFENDER-INIT
                                         empty
                                         LOB-FIRE-INIT
                                         HEALTH-INIT))

(define WORLD-DRAW-STATE (make-world DEFENDER-INIT
                                     LOF-MISSILES-ST1
                                     LOF-BULLETS-ST1
                                     HEALTH-INIT))
(define WORLD-END (make-world DEFENDER-INIT
                              LOF-MISSILES-ST1
                              LOF-BULLETS-ST1
                              HEALTH-OVER))
(define WORLD-ANIM-INIT (make-world DEFENDER-INIT
                                    LOF-MISSILES-ANIM-INIT
                                    LOF-BULLETS-ANIM-INIT
                                    HEALTH-INIT))
(define WORLD-ANIM-END (make-world DEFENDER-MOVED
                                   LOF-MISSILES-ANIM-END
                                   LOF-BULLETS-ANIM-END
                                   HEALTH-REDUCED))

;;-----------------------------ON-DRAW-FUNCTIONS------------------------------;;

;;; Signature:
;; world-draw : World -> Image

;;; Purpose: Given a world, return an image of the world containing its
;;           defender, missiles and bullets and health.

;;; Function Definition:
(define (world-draw world)
  (draw-missiles world
                 (draw-bullets world
                               (draw-health (world-health world)
                                            (draw-defender
                                             (world-defender world))))))

;;; Tests:
(check-expect (world-draw WORLD-DRAW-STATE) WORLD-DRAW-IMAGE)


;;; Signature:
;; draw-defender : Defender -> Image

;;; Purpose: given a defender, renders the image of the defender.

;;; Function Definition:
(define (draw-defender defender)
  (place-image DEFENDER-IMAGE
               (posn-x (defender-loc defender))
               (posn-y (defender-loc defender))
               BACKGROUND))

;;; Tests:
(check-expect (draw-defender DEFENDER-INIT) DEFENDER-INIT-IMAGE)


;;; Signature:
;; draw-health : Health Image -> Image

;;; Purpose: Given the health of the defender and a canvas, render its
;;           image on the canvas.

;;; Function Definition:
(define (draw-health health canvas)
  (place-image (text (health->string health) HEALTH-FONT-SIZE HEALTH-FONT-COLOR)
               HEALTH-X
               HEALTH-Y
               canvas))

;;; Tests:
(check-expect (draw-health HEALTH-INIT DEFENDER-INIT-IMAGE) HEALTH-INIT-IMAGE)


;;; Signature:
;; health->string : Health -> String

;;; Purpose: Given the health of the invader, return the string to be rendered
;;           as image.

;;; Function Definition:
(define (health->string health)
  (string-append HEALTH-TEXT (number->string health)))

;;; Tests:
(check-expect (health->string HEALTH-INIT) "Health : 5")


;;; Signature:
;; draw-list : Lof[Posn] Image Image -> Image

;;; Purpose: Given a list of Posn, its image and a canvas, renders the
;;           images for the list on the canvas

;;; Function Definition:
(define (draw-list lop image canvas)
  (foldr (λ (pos img) ;; Posn Image -> Image
           (place-image image
                        (posn-x pos)
                        (posn-y pos)
                        img))
         canvas
         lop))

;;; Tests:
(check-expect (draw-list LOF-BULLETS-ST1 BULLET-IMAGE HEALTH-INIT-IMAGE)
              LOF-BULLETS-ST1-IMAGE)
(check-expect (draw-list LOF-MISSILES-ST1 MISSILE-IMAGE LOF-BULLETS-ST1-IMAGE)
              LOF-MISSILES-ST1-IMAGE)

;;; Signature:
;; draw-bullets : World Image -> Image

;;; Purpose: Given a world and a canvas, render the bullets of the world
;;           on the canvas.

;;; Function Definition:
(define (draw-bullets world canvas)
  (draw-list (world-bullets world)
             BULLET-IMAGE
             canvas))


;;; Signature:
;; draw-missiles : World Image -> Image

;;; Purpose: Given a world and the canvas, render the missiles of the world
;;           on the canvas.

;;; Function Definition:
(define (draw-missiles world canvas)
  (draw-list (world-missiles world)
             MISSILE-IMAGE
             canvas))


;;------------------------------ON-KEY-FUNCTIONS------------------------------;;


;;; Signature:
;; defender-controller : World KeyEvent -> World

;;; Purpose: Given a world and a key event, handle the defender controls and
;;            return the updated world.

;;; Function Definition:
(define (defender-controller world key-event)
  (cond
    [(key=? key-event LEFT-ARROW) (world-def-dir-alter world LEFT)]
    [(key=? key-event RIGHT-ARROW) (world-def-dir-alter world RIGHT)]
    [(key=? key-event SPACE) (fire-def-bullet world)]
    [else world]))

;;; Tests:
(check-expect (defender-controller WORLD-INIT "left") WORLD-INIT)
(check-expect (defender-controller WORLD-INIT-DEF-DIR-UPD "left") WORLD-INIT)
(check-expect (defender-controller WORLD-INIT "right") WORLD-INIT-DEF-DIR-UPD)
(check-expect (defender-controller WORLD-INIT-DEF-DIR-UPD "right")
              WORLD-INIT-DEF-DIR-UPD)
(check-expect (defender-controller WORLD-INIT " ") WORLD-INIT-BUL-FIRED)
(check-expect (defender-controller WORLD-INIT "s") WORLD-INIT)

;;; Signature:
;; world-def-dir-alter : World Direction -> World

;;; Purpose: Given a world and a direction, return a world with defender's
;;           direction modified as per the given direction.

;;; Function Definition:
(define (world-def-dir-alter world direction)
  (local (
          ;; def-dir-alter : Defender Direction -> Defender
          ;; Given a defender and a direction, return the defender with its
          ;; direction updated accordingly.
          (define (def-dir-alter defender direction)
            (make-defender direction
                           (defender-loc defender))))
    (make-world (def-dir-alter (world-defender world) direction)
                (world-missiles world)
                (world-bullets world)
                (world-health world))))

;;; Tests:
(check-expect (world-def-dir-alter WORLD-INIT LEFT) WORLD-INIT)
(check-expect (world-def-dir-alter WORLD-INIT RIGHT) WORLD-INIT-DEF-DIR-UPD)

;;; Signature:
;; fire-def-bullet : World -> World

;;; Purpose: Given a world, return the world with a defender bullet added
;;           to the defender list of bullets.

;;; Function Definition:
(define (fire-def-bullet world)
  (make-world (world-defender world)
              (world-missiles world)
              (add-bullet (world-defender world) (world-bullets world))
              (world-health world)))

;;; Tests:
(check-expect (fire-def-bullet WORLD-INIT) WORLD-INIT-BUL-FIRED)

;;; Signature:
;; add-bullet : Defender Lof[Bullet] -> Lof[Bullet]

;;; Purpose: Given a defender and a list of bullets, return the list of bullets
;;           after adding a new bullet to the list of bullets.

;;; Function Definition:
(define (add-bullet defender lob)
  (cons (defender-loc defender) lob))



;;-----------------------------ON-TICK-FUNCTIONS------------------------------;;

;;******************************MOVING-DEFENDER*******************************;;

;;; Signature:
;; move-defender : Defender -> Defender

;;; Purpose: given a defender, move the defender.

;;; Function Definition:
(define (move-defender defender)
  (if (symbol=? (defender-dir defender) LEFT)
      (make-defender LEFT
                     (move-def-left (defender-loc defender)))
      (make-defender RIGHT
                     (move-def-right (defender-loc defender)))))

;;; Tests:
(check-expect (move-defender DEFENDER-INIT) DEFENDER-MOVED)
(check-expect (move-defender DEFENDER-DIR-CH) DEFENDER-DIR-CH-MOVED)
(check-expect (move-defender DEF-LEFT-OVERFLOW) DEF-LEFT-ALIGN)
(check-expect (move-defender DEF-RIGHT-OVERFLOW) DEF-RIGHT-ALIGN)

;;; Signature:
;; move-def-left : Location -> Location

;;; Purpose: Given the location of the defender, return the
;;           updated location of the defender moved to the left.

;;; Function Definition:
(define (move-def-left loc)
  (if (< (- (- (posn-x loc) DEF-HALF-WIDTH) DEF-SPEED) 0)
      (make-posn DEF-LEFT-EDGE-X (posn-y loc))
      (move-loc loc OP-LEFT)))

;;; Signature:
;; move-def-right : Location -> Location

;;; Purpose: Given the location of the defender, return the
;;           updated location of the defender moved to the right.

;;; Function Definition:
(define (move-def-right loc)
  (if (> (+ (+ (posn-x loc) DEF-HALF-WIDTH) DEF-SPEED) SCENE-WIDTH)
      (make-posn DEF-RIGHT-EDGE-X (posn-y loc))
      (move-loc loc OP-RIGHT)))

;;; Signature:
;; move-loc : Location [Number Number -> Number] -> Location

;;; Purpose: Given a location and a operator that takes two numbers and returns
;;           a number, return the new location.

;;; Function Definition:
(define (move-loc loc op)
  (make-posn (op (posn-x loc) DEF-SPEED)
             (posn-y loc)))

;;****************************GENERATING-MISSILES*****************************;;

;;; Signature:
;; combine-lists : Lof[X] Lof[Y] -> Lof[Y]

;;; Purpose: Given two lists, merges the first list into the second list
;;           and returns the combined second list.

;;; Function Definition:
(define (combine-lists list-a list-b)
  (foldr (λ (elem-a acc-list-b) ;; X Lof[Y] -> Lof[Y]
           (cons elem-a acc-list-b)) list-b list-a))

;;; Tests:
(check-expect (combine-lists empty LIST-A) LIST-A)
(check-expect (combine-lists LIST-A LIST-B) LIST-C)

;;; Signature:
;; gen-new-list : NonNegInteger -> Lof[Posn]

;;; Purpose: Given a limit, return a generated list of posns, that contain
;;           the limit number of elements.

;;; Function Definition:
(define (gen-new-list limit)
  (build-list limit (λ (limit) ;; NonNegInteger -> Lof[Posn]
                      (gen-rand-posn (random RAND-X-LIMIT)))))

;;; Tests:
(check-random (gen-new-list 5)
              (build-list 5
                          (λ (x) ;; NonNegInteger -> Lof[Posn]
                            (gen-rand-posn (random RAND-X-LIMIT)))))
(check-random (gen-new-list 0)
              empty)


;;; Signature:
;; generate-missiles : Lof[Missile] -> Lof[Missile]

;;; Purpose: Given a list of missiles, generate new missiles if they are atleast
;;           less than the limit and add them to the existing list of missiles.

;;; Function Definition:
(define (generate-missiles lom)
  (local
    (
     ;; count-list : Lof[X] -> NonNegInteger
     ;; Given a list, return the number of elements in the list.
     (define (count-list list)
       (foldr (λ(element number)  ;; X NonNegInteger -> NonNegInteger
                (+ 1 number))
              0
              list)))
    (if (>= (count-list lom) MISSILE-LIMIT)
        lom
        (combine-lists (gen-new-list (random MAX-MIS-PER-TICK))
                       lom))))

;;; Tests:
(check-expect (generate-missiles LOF-MISSILES-FULL)
              LOF-MISSILES-FULL)
(check-random (generate-missiles LOF-MISSILES-ST1)
              (combine-lists (gen-new-list (random MAX-MIS-PER-TICK))
                             LOF-MISSILES-ST1))
;;; Signature:
;; gen-rand-posn : NonNegInteger -> Posn

;;; Purpose: Generate a posn with the given x-coordinate.

;;; Function Definition:
(define (gen-rand-posn x-coord)
  (if (> x-coord 10)
      (make-posn x-coord
                 (gen-y-coord x-coord))
      (gen-rand-posn (+ X-AXIS-ADJUSTMENT x-coord))))

;;; Tests:
(check-expect (gen-rand-posn 5)
              (make-posn (+ 5 X-AXIS-ADJUSTMENT)
                         MISSILE-SPAWN-Y-B))
(check-expect (gen-rand-posn 460)
              (make-posn 460
                         MISSILE-SPAWN-Y-A))

;;; Signature:
;; gen-y-coord : NonNegInteger -> NonNegInteger

;;; Purpose: Given the x-coordinate of a point, generate the y-coordinate.

;;; Function Definition:
(define (gen-y-coord x-coord)
  (if (= (remainder x-coord 2) 0)
      MISSILE-SPAWN-Y-A
      MISSILE-SPAWN-Y-B))

;;; Tests:
(check-expect (gen-y-coord 11) MISSILE-SPAWN-Y-B)
(check-expect (gen-y-coord 20) MISSILE-SPAWN-Y-A)


;;**************************MOVING-MISSILES-&-BULLETS*************************;;

;;; Signature:
;; move-posns : Lof[Posn] NonNegInteger [Number Number -> Number] -> Lof[Posn]

;;; Purpose: Given a list of posn, speed and a function, return the list of posn
;;           after moving the posn.

;;; Function Definition:
(define (move-posns lop speed op)
  (map (λ (pos) ;; Posn -> Posn
         (make-posn (posn-x pos)
                    (op (posn-y pos) speed)))
       lop))

;;; Tests:
(check-expect (move-posns empty BULLET-SPEED OP-UP) empty)
(check-expect (move-posns LOF-BULLETS-ST1 BULLET-SPEED OP-UP)
              LOF-BULLETS-ST1-MOVED)
(check-expect (move-posns LOF-MISSILES-ST1 MISSILE-SPEED OP-DOWN)
              LOF-MISSILES-ST1-MOVED)

;;**********************FILTERING-HIT-MISSILES-&-BULLETS**********************;;

;;; Signature:
;; missile-bullet-intersect? : Missile Bullet -> Boolean

;;; Purpose: checks if the given missile and bullet intersects.

;;; Function Definition:
(define (missile-bullet-intersect? missile bullet)
  (<= (+ (sqr (- (posn-x missile) (posn-x bullet)))
         (sqr (- (posn-y missile) (posn-y bullet))))
      (sqr (+ MISSILE-RADIUS BULLET-RADIUS))))

;;; Tests:
(check-expect (missile-bullet-intersect? (make-posn 300 260)
                                         (make-posn 300 290))
              FALSE)
(check-expect (missile-bullet-intersect? (make-posn 300 260)
                                         (make-posn 300 271))
              TRUE)
(check-expect (missile-bullet-intersect? (make-posn 300 260)
                                         (make-posn 300 265))
              TRUE)
(check-expect (missile-bullet-intersect? (make-posn 300 260)
                                         (make-posn 300 260))
              TRUE)

;;; Signature:
;; missile-hit-filter : Lof[Missile] Lof[Bullet] -> Lof[Missile]

;;; Purpose: Given a list of missiles and a list of bullets, filter the
;;           missiles that are not hit by any of the bullets.

;;; Function Definition:
(define (missile-hit-filter lom lob)
  (local
    (;; missile-lob-hit? : Missile Lof[Bullet] -> Boolean
     ;; Given a missile and a list of bullets, determines if the missile
     ;; is hit by any of the bullets in the list.
     (define (missile-lob-hit? missile lob)
       (ormap (λ (bullet)  ;; Bullet -> Boolean
                (missile-bullet-intersect? missile bullet)) lob)))
    (filter (λ (missile)  ;; Missile -> Boolean
              (not (missile-lob-hit? missile lob)))
            lom)))

;;; Tests:
(check-expect (missile-hit-filter LOF-MISSILES-ST1 LOF-BULLETS-ST1)
              LOF-MISSILES-ST1)
(check-expect (missile-hit-filter LOF-MISSILES-FT LOF-BULLETS-FT)
              LOF-MISSILES-FILTERED)

;;; Signature:
;; bullet-hit-filter : Lof[Bullet] Lof[Missile] -> Lof[Bullet]

;;; Purpose: Given a list of bullets and a list of missiles, filter the
;;           bullets that are not hit by any of the missiles.

;;; Function Definition:
(define (bullet-hit-filter lob lom)
  (local
    (;; bullet-lom-hit? : Bullet Lof[Missile] -> Boolean
     ;; Given a bullet and a list of missiles, determines if the bullet
     ;; hit any of the missiles in the list.
     (define (bullet-lom-hit? bullet lom)
       (ormap (λ (missile)  ;; Missile -> Boolean
                (missile-bullet-intersect? missile bullet)) lom)))
    (filter (λ (bullet)  ;; Bullet -> Boolean
              (not (bullet-lom-hit? bullet lom)))
            lob)))

;;; Tests:
(check-expect (bullet-hit-filter LOF-BULLETS-ST1 LOF-MISSILES-ST1)
              LOF-BULLETS-ST1)
(check-expect (bullet-hit-filter LOF-BULLETS-FT LOF-MISSILES-FT)
              LOF-BULLETS-FILTERED)

;;*****************************CALCULATING-LIVES******************************;;

;;; Signature:
;; count-missiles-oob : Lof[Missile] -> NonNegInteger

;;; Purpose: Given a list of missiles, count the number of missiles that have
;;           gone out of the scene.

;;; Function Definition:
(define (count-missiles-oob lom)
  (foldr (λ (missile number)  ;; Missile NonNegInteger -> NonNegInteger
           (if (> (- (posn-y missile) MISSILE-RADIUS) 500)
               (add1 number)
               number))
         0
         lom))

;;; Tests:
(check-expect (count-missiles-oob LOF-MISSILES-ST1) 0)
(check-expect (count-missiles-oob (list (make-posn 100 510))) 0)
(check-expect (count-missiles-oob LOF-MISSILES-FT) 1)
(check-expect (count-missiles-oob (list (make-posn 100 511)
                                        (make-posn 200 511))) 2)

;;; Signature:
;; calc-health : Health Lof[Missile] -> Health

;;; Purpose: Given the health and the list of missiles, calculate the current
;;           health.

;;; Function Definition:
(define (calc-health health lom)
  (- health (count-missiles-oob lom)))

;;; Tests:
(check-expect (calc-health HEALTH-INIT LOF-MISSILES-ST1) HEALTH-INIT)
(check-expect (calc-health HEALTH-INIT LOF-MISSILES-FT) HEALTH-REDUCED)

;;**********************FILTERING-OOB-MISSILES-&-BULLETS**********************;;

;;; Signature:
;; filter-missiles-oob : Lof[Missile] -> Lof[Missile]

;;; Purpose: filter the missiles that are out of bounds of the bottom of
;;           the scene.

;;; Function Definition:
(define (filter-missiles-oob lom)
  (filter (λ (missile) ;; Missile -> Boolean
            (not (> (- (posn-y missile) MISSILE-RADIUS) SCENE-HEIGHT)))
          lom))

;;; Tests:
(check-expect (filter-missiles-oob LOF-MISSILES-ST1) LOF-MISSILES-ST1)
(check-expect (filter-missiles-oob LOF-MISSILES-FT) LOF-MISSILES-OOB-FILTERED)

;;; Signature:
;; filter-bullets-oob : Lof[Bullet] -> Lof[Bullet]

;;; Purpose: filter the bullets that are out of bounds of the top of
;;           the scene.

;;; Function Definition:
(define (filter-bullets-oob lob)
  (filter (λ (bullet) ;; Bullet -> Boolean
            (not (< (+ (posn-y bullet) BULLET-RADIUS) 0)))
          lob))

;;; Tests:
(check-expect (filter-bullets-oob LOF-BULLETS-ST1) LOF-BULLETS-ST1)
(check-expect (filter-bullets-oob LOF-BULLETS-FT) LOF-BULLETS-OOB-FILTERED)

;;************************ON-TICK-WORLD-TRANSFORMATION************************;;

;-----------------------------------STEP-1-------------------------------------;

;;; Signature:
;; move-def-gen-missiles : World -> World

;;; Purpose: Given a world, move the defender and generate the missiles for
;;           the tick.

;;; Function Definition:
(define (move-def-gen-missiles world)
  (make-world (move-defender (world-defender world))
              (generate-missiles (world-missiles world))
              (world-bullets world)
              (world-health world)))



;-----------------------------------STEP-2-------------------------------------;

;;; Signature:
;; move-missiles-bullets : World -> World

;;; Purpose: Given a world, move the missiles and the bullets.

;;; Function Definition:
(define (move-missiles-bullets world)
  (make-world (world-defender world)
              (move-posns (world-missiles world) MISSILE-SPEED OP-DOWN)
              (move-posns (world-bullets world) BULLET-SPEED OP-UP)
              (world-health world)))


;-----------------------------------STEP-3-------------------------------------;

;;; Signature:
;; rem-hit-bul-mis-calc-health : World -> World

;;; Purpose: Given a world, remove the hit bullets and missiles and calculate
;;           the health of the defender

;;; Function Definition:
(define (rem-hit-bul-mis-calc-health world)
  (make-world (world-defender world)
              (missile-hit-filter (world-missiles world)
                                  (world-bullets world))
              (bullet-hit-filter (world-bullets world)
                                 (world-missiles world))
              (calc-health (world-health world)
                           (world-missiles world))))


;-----------------------------------STEP-4-------------------------------------;

;;; Signature:
;; remove-oob-bul-mis : World -> World

;;; Purpose: Given a world, remove the hit missiles and bullets.

;;; Function Definition:
(define (remove-oob-bul-mis world)
  (make-world (world-defender world)
              (filter-missiles-oob (world-missiles world))
              (filter-bullets-oob (world-bullets world))
              (world-health world)))


;---------------------------------FINAL-STEP-----------------------------------;

;;; Signature:
;; animate-tock : World -> World

;;; Purpose: Given a world, change the world state on every tick of the clock.

;;; Function Definition:
(define (animate-tock world)
  (remove-oob-bul-mis
   (rem-hit-bul-mis-calc-health
    (move-missiles-bullets
     (move-def-gen-missiles world)))))

;;; Tests:
(check-expect (animate-tock WORLD-ANIM-INIT)
              WORLD-ANIM-END)

;;----------------------------STOP-WHEN-FUNCTION------------------------------;;

;;; Signature:
;; game-end? : World -> Boolean

;;; Purpose: Given a world, determine if the game has to end.

;;; Function Definition:
(define (game-end? world)
  (<= (world-health world) 0))

;;; Tests:
(check-expect (game-end? WORLD-INIT) FALSE)
(check-expect (game-end? WORLD-DRAW-STATE) FALSE)
(check-expect (game-end? WORLD-END) TRUE)

;;----------------------------BIG-BANG-FUNCTION-------------------------------;;

(big-bang WORLD-INIT
          (to-draw world-draw)
          (on-tick animate-tock 0.1)
          (on-key defender-controller)
          (stop-when game-end?))

;;*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-T-H-E-*-E-N-D-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-;;