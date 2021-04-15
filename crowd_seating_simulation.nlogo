globals [
  count1 ; per contare il numero di turtles da creare
  stage ; zona del palco
  place_chairs ; zona marrone scuro
  green_area ; zona di spawn
  fila ; zone grigie
  dist-neigh ; mostra la distanza base tra una sedia e l'altra
  c_number ; numero di sedie
  place_to_move ; zona marrone chiaro dove le tartarughe si possone muovere per arrivare al goal
  check_dis ; variabile per controllare se la distanza minima è cambiata
  seating-patches ; sedie

]

patches-own [
  available ; per sapere se una sedia è libera
  attraction ; indice di attrazione dato dalla somma di ppalco e di pvicini
  distanza_palco ; valore per distanza della sedia dal palco
  distanza_vicini ; valore per distanza dai vicini
  ppalco ; formula per calcolare il peso del palco
  pvicini ; formula per calcolare il peso in base ai vicini

  ;parametri per A star
  cost-path
  father
  visited?
  active?
  final-cost
]


turtles-own[
  goal ; destinazione della turtle
  start ; punto di partenza della turtle

  path; percorso ottimale da start a goal
  next-move ; prossima patch in cui muoversi
]


to setup
  clear-all
  set-default-shape turtles "person"
  set-up-world ;inizializzazione del mondo
               ;create_square

  ask patches [setup-path]
  ;; start the clock
  set count1 n_turtles


  compute_attraction

  reset-ticks
end

to go
  set c_number count patches with [pcolor = blue]
  set_place_to_move
  set check_dis distanza_min
  ifelse c_number >= n_turtles[

    if count1 > 0 [
      create-turtles 1 [
        set color white

        set size 1.5
        let spawn-point  patches with [pycor <= -14 and pycor > -18 ]
        move-to-empty-one-of spawn-point
        set goal min-one-of patches with [available = true] [attraction]
        ;ask goal [set booked true]

        set label who
        set label-color black
      ]

      set count1 count1 - 1
      ask turtles [start-turtles]
    ]
  ]
  [  user-message (word "Numero di persone maggiore delle sedie disponibili... Diminuire numero persone o aumentare numero sedie")]


  ;debug
  compute_attraction
  move_turtles
  tick
end





;##################INIZIO FUNZIONI DI SETUP#####################
to set-up-world

  ;create the stage
  set stage patches with [ pycor >  max-pycor - 6]
  ask stage [set pcolor red]

  set place_chairs patches with [pycor <= max-pycor - 6 and pycor > -13 ]
  ask place_chairs [set pcolor brown]

    ;; create the spawn area
  set green_area patches with [pycor <= -14   ]
  ask green_area [ set pcolor green ]

  ask patch (((max-pxcor + min-pxcor)/ 2) + 2) ((max-pycor + (max-pycor - 6))/ 2) [
    set stage self
    set plabel-color black
  ]
   ask stage [ set plabel "STAGE" ]


  ;inizializzazione indice di attrazione e file
  let i 8
  ;let lcl 1.25
  ask patches[
    while[-8 <= i] [

      set fila patches with [ pycor = i
        and pxcor >= -12
        and pxcor <= 12]

      ask patches with [ pycor = i
        and pxcor >= -12
        and pxcor <= 12]
      [ set pcolor gray]
      set i i - 4
    ]
  ]

  ask patches with [ pxcor mod column = 0
    and pycor mod 4 = 0
    and pycor < 9
    and pycor > -9
    and pxcor >= -12
    and pxcor <= 12]
  [ set pcolor blue

    set available true
  ]

  let m 0
  let a 8
  let lcl 1.25
  while [ -8 <= a][
    ifelse column = 5
    [set m -10]
    [set m -12]

    while[m <= 12 ][
      ask patches with [ pxcor = m
        and pycor = a
      ]
      [ set attraction lcl]
      set m m + column
      set dist-neigh column - 1
    ]
    set lcl lcl - 0.25
    set a a - 4
  ]

  let n 7
  set m 0
  ;inizializza i colori degli schienali
  while [ -9 <= n][
    ifelse column = 5
    [set m -10]
    [set m -12]

    while[m <= 12 ][
      ask patches with [ pxcor = m
        and pycor = n
      ]
      [ set pcolor yellow ]
      set m m + column
      set dist-neigh column - 1
    ]
    set n n - 4
  ]

   set seating-patches patches with [pcolor = blue]
end

to set_place_to_move

  set place_to_move patches with [ pcolor = 37 or pcolor = blue  ]
  ask place_to_move[
    set father nobody
    set cost-path 0
    set visited? false
    set active? false]

end
; setta il path da far seguire alle tartarughe
to setup-path
  ;colonne path
  ask patches with [pxcor = -14  and pycor <= 9 and  pycor >= -11]
    [ set pcolor 37]
   ask patches with [pxcor = 14  and pycor <= 9 and  pycor >= -11]
    [ set pcolor 37]
  ;righe path
  ask patches with [pxcor >= -14 and pxcor <= 14 and pycor = 10]
  [ set pcolor 37]
  ask patches with [pxcor > -14 and pxcor < 14 and pycor = 9]
  [ set pcolor 37]
  ask patches with [pxcor > -14 and pxcor < 14 and pycor = 5]
    [ set pcolor 37]
  ask patches with [pxcor > -14 and pxcor < 14 and pycor = 1]
    [ set pcolor 37]
  ask patches with [pxcor > -14 and pxcor < 14 and pycor = -3]
    [ set pcolor 37]
  ask patches with [pxcor > -14 and pxcor < 14 and pycor = -7]
    [ set pcolor 37]
  ask patches with [pxcor > -14 and pxcor < 14 and pycor = -11 ]
    [ set pcolor 37]
  ask patches with [pxcor  >= -1 and pxcor <= 1 and pycor = -12 ]
    [ set pcolor 37]
  ask patches with [pxcor  >= -11 and pxcor <= -9 and pycor = -12 ]
      [ set pcolor 37]
  ask patches with [pxcor  >= 9 and pxcor <= 11 and pycor = -12 ]
    [ set pcolor 37]


end

; ################## FINE FUNZIONI DI SETUP ##################


;####################INIZIO HELP-FUNCTION ##############

to add_turtle
  let count_turtles count turtles
  ifelse c_number > count_turtles[
    create-turtles 1 [
      set color white

      set size 1.5
      let spawn-point  patches with [pycor <= -14 and pycor > -18 ]
      move-to-empty-one-of spawn-point
      set goal min-one-of patches with [available = true] [attraction]
      set label who
      set label-color black
    ]
    tick
    ask turtles [start-turtles]
  ]
  [  user-message (word "Numero di persone maggiore delle sedie disponibili... Diminuire numero persone o aumentare numero sedie")]
end


; calcola peso palco
to compute_ppalco
  ask patches with [pcolor = blue] [ set distanza_palco 13 - pycor]
  ask patches with [pcolor = blue] [ set ppalco distanza_palco * peso_palco ]
end

;calcola peso della sedia in base ai vicini che stanno a una distanza minore di distanza_min
to compute_pvicini
  ask patches with [pcolor = blue] [
    let i 1
    let temp 0
    while [i <= distanza_min][
      set distanza_vicini i

      if [available] of patch (pxcor + i) pycor = false [
        set temp temp + (distanza_min + 1 - distanza_vicini) * peso_vicini
      ]

      if [available] of patch (pxcor - i) pycor = false [
         set temp temp + (distanza_min + 1 - distanza_vicini) * peso_vicini
      ]
      ask patch pxcor pycor [set pvicini temp]
      set i i + 1
    ]
  ]
end

; calcola attraction di ogni sedia
to compute_attraction
  compute_ppalco
  compute_pvicini
  ask patches with [pcolor = blue] [ set attraction ppalco + pvicini]
end


;####################FINE HELP-FUNCTION ##############

;####################INIZIO FUNZIONI PER MOVIMENTO##############



;inizializza la prima patch nel percorso path
to start-turtles
  if [pcolor] of patch-here = green[
    set start one-of patches with [pcolor = 37 and pycor = -12]
    move-to start
  ]
end

to move_turtles

  ask turtles [

    compute_attraction
    ;caso in cui la mia sedia è occupata da qualcun altro
    if [available] of goal = false and patch-here != goal [
      set goal min-one-of patches with [available = true] [attraction]
    ]
    ;controlla se ci sono sedie disponibili
    if any? seating-patches with [available] = true  [
      ;se non mi trovo nel mio goal quindi sto camminando per arrivarci
      ifelse patch-here != goal[
        ;controlla se esiste un goal migliore rispetto al mio perchè parametri cambiati
        let old_goal goal
        set goal min-one-of patches with [available = true] [attraction]
        ifelse [attraction] of old_goal = [attraction] of goal and patch-here != goal [
          set goal old_goal
          walk-towards-goal
        ]
        [ walk-towards-goal]
      ][
        ;sono nel goal e controllo se ci sta una sedia migliore
        let possible_goal min-one-of patches with [available = true] [attraction]
        ifelse [attraction] of patch-here > [attraction] of possible_goal [
          ask patch-here [ set available true]
          set goal possible_goal
          walk-towards-goal
        ][stop]
      ]
    ]
  ]

end



to walk-towards-goal
  compute-path
  set path remove-item 0 path
  if [path] of turtles != false and length path > 0[
    set next-move first path
    set path remove-item 0 path
    move-to next-move
    if next-move = goal [
      ask goal [set available false]
      stop
    ]
  ]

end



;; Nonetheless, to make a nice visualization
;; this procedure is used to ensure that we only have one
;; turtle per patch.
to move-to-empty-one-of [locations]  ;; turtle procedure
  move-to one-of locations

  while [any? other turtles-here] [
    move-to one-of locations
  ]
end

;utility-function per ricalcolare il path da seguire passando il nuovo goal
to compute-path
  set path  A* patch-here goal place_to_move
end

;###### A star procedure#####
to-report A* [#Start #Goal #valid-map]
  ; clear all the information in the agents, and reset them
  ask #valid-map with [visited?]
  [
    set father nobody
    set cost-path 0
    set visited? false
    set active? false
  ]
  ; Active the starting point to begin the searching loop
  ask #Start
  [
    set father self
    set visited? true
    set active? true

  ]
  ; exists? indicates if in some instant of the search there are no options to continue.
  ; In this case, there is no path connecting #Start and #Goal
  let exists? true
  ; The searching loop is executed while we don't reach the #Goal and we think a path exists
  while [not [visited?] of #Goal and exists?]
  [
    ; We only work on the valid pacthes that are active
    let options #valid-map with [active?]
    ; If any
    ifelse any? options
    [
      ; Take one of the active patches with minimal expected cost
      ask min-one-of options [Total-expected-cost #Goal]
      [
        ; Store its real cost (to reach it) to compute the real cost of its children
        let Cost-path-father Cost-path
        ; and deactivate it, because its children will be computed right now
        set active? false
        ; Compute its valid neighbors and look for an extension of the path
        let valid-neighbors neighbors with [member? self #valid-map]
        ask valid-neighbors
        [
          ; There are 2 types of valid neighbors:
          ;   - Those that have never been visited (therefore, the path we are building is the
          ;       best for them right now)
          ;   - Those that have been visited previously (therefore we must check if the path we
          ;       are building is better or not, by comparing its expected length with the one
          ;       stored in the patch)
          ; One trick to work with both type uniformly is to give for the first case an upper
          ;   bound big enough to be sure that the new path will always be smaller.
          let t ifelse-value visited? [ Total-expected-cost #Goal] [2 ^ 20]
          ; If this temporal cost is worse than the new one, we substitute the information in
          ;   the patch to store the new one (with the neighbors of the first case, it will be
          ;   always the case)
          if t > (Cost-path-father + distance myself + Heuristic #Goal)
          [
            ; The current patch becomes the father of its neighbor in the new path
            set father myself
            set visited? true
            set active? true
            ; and store the real cost in the neighbor from the real cost of its father
            set Cost-path Cost-path-father + distance father
            set Final-Cost precision Cost-path 3

          ]
          ;show t
        ]
      ]
    ]
    ; If there are no more options, there is no path between #Start and #Goal
    [
      set exists? false
    ] ]
  ; After the searching loop, if there exists a path
  ifelse exists?
  [
    ; We extract the list of patches in the path, form #Start to #Goal by jumping back from
    ;   #Goal to #Start by using the fathers of every patch
    let current #Goal
    set Final-Cost (precision [Cost-path] of #Goal 3)
    let rep (list current)
    While [current != #Start]
    [
      set current [father] of current
      set rep fput current rep
    ]
    report rep
  ]
  [
    ; Otherwise, there is no path, and we return False
    report false
  ]
end

to-report Total-expected-cost [goal_1]
  report cost-path + Heuristic goal_1
end

to-report Heuristic [goal_2]
  report distance goal_2
end

;####################FINE FUNZIONI PER MOVIMENTO##############
@#$#@#$#@
GRAPHICS-WINDOW
197
10
760
574
-1
-1
15.0
1
20
1
1
1
0
1
1
1
-18
18
-18
18
0
0
1
ticks
30.0

SLIDER
795
52
967
85
n_turtles
n_turtles
1
65
30.0
1
1
NIL
HORIZONTAL

SLIDER
794
110
966
143
column
column
2
5
2.0
1
1
NIL
HORIZONTAL

BUTTON
799
205
863
238
Setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
801
14
951
33
Setup del mondo
15
0.0
1

TEXTBOX
804
172
954
191
Bottoni setup e go\n
15
0.0
1

BUTTON
881
205
944
238
Go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
1094
62
1266
95
distanza_min
distanza_min
1
10
4.0
1
1
NIL
HORIZONTAL

TEXTBOX
1100
18
1250
56
Parametri per modifica movimento\n
15
0.0
1

SLIDER
1095
109
1267
142
peso_palco
peso_palco
1
50
1.0
1
1
NIL
HORIZONTAL

SLIDER
1094
163
1266
196
peso_vicini
peso_vicini
0
50
50.0
1
1
NIL
HORIZONTAL

BUTTON
799
258
911
291
Aggiungi turtle
add_turtle
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
1099
233
1182
278
Persone
count turtles
17
1
11

MONITOR
1101
299
1158
344
Sedie
count patches with [pcolor = blue]
17
1
11

MONITOR
1101
363
1194
408
Number of tick
ticks
17
1
11

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
