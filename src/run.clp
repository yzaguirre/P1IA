(deftemplate campeon
	(slot nombre (type STRING))
  (multislot tiene-rols)
	(slot salud (type INTEGER))
	(slot ataque (type INTEGER))
	(slot hechizo (type INTEGER))
	(slot dificultad (type INTEGER))
	(slot fecha (type STRING))
	(slot puntosip (type INTEGER))
	(slot puntosrp (type INTEGER))
	(slot prioridad (type INTEGER))
  (slot ban (type INTEGER))
)
(deftemplate prioridad
  (slot tipo (type STRING))
  (slot champ1 (type STRING))
  (slot champ2 (type STRING))
  (slot flag (type INTEGER))
)
; Aatrox
(defglobal ?*op1* = 0)
(defglobal ?*op2* = 0)
(defglobal ?*op3* = 0)
(defglobal ?*equipo* = 0)
(defglobal ?*player* = 0)
(defglobal ?*candidatos* = 0)
(defglobal ?*prioridades* = 0)
;(defrule le-fue-bien
;	(salience 187)
;	(comolefue 1)
;	?p <- (campeon (nombre ?**))
;=>
;	(modify ?p (+ prioridad 1))
;)
;(defrule le-fue-mal
;	(salience 187)
;	(comolefue 0)
;	?p <- (campeon (nombre ?**))
;=>
;	(modify ?p (- prioridad 1))
;)
;(defrule como-le-fue
;(declare salience 186)
;	(initial-fact)
;=>
;	(printout t "Le fue bien? si o no: ")
;	(assert (comolefue =(readline)))
;)
; ORDEN DE ELECCION
; 1a
; 1m
; 2m
; 2a
; 3a
; 3m
; 4m
; 4a
; 5a
; 5m

;(
;  (4)
;  (Pida su jugador)
;  (5)
;  )
; -1 - 5
(defrule prioridad-gw
  (declare (salience 198)); mas alto que los ingreso-#equipo
  (juega-con ?jugador ?equipo ?campeon)
  ?f0 <- (prioridad (tipo "gw") (champ1 ?campeon) (champ2 ?gw) (flag 0))
  (juega-con ?jug&~?jugador ?equipo ?gw) ; existe el gw en su equipo
  ?f1 <- (campeon (nombre ?campeon) (prioridad ?prioridad))
=>
  (modify ?f0 (flag 1))
  (modify ?f1 (prioridad (+ ?prioridad 1)))
  (printout t "Subiendo prioridad a " ?campeon " de jugador " ?jugador " y equipo " ?equipo " porque es gw con " ?gw crlf)
)
(defrule prioridad-ga
  (declare (salience 198)); mas alto que los ingreso-#equipo
  (juega-con ?jugador ?equipo ?campeon)
  ?f0 <- (prioridad (tipo "ga") (champ1 ?campeon) (champ2 ?ga) (flag 0))
  (juega-con ?jug ?equi&~?equipo ?ga) ; no existe el ga en su equipo
  ?f1 <- (campeon (nombre ?campeon) (prioridad ?prioridad))
=>
  (modify ?f0 (flag 1))
  (modify ?f1 (prioridad (+ ?prioridad 1)))
  (printout t "Subiendo prioridad a " ?campeon " de jugador " ?jugador " y equipo " ?equipo " porque es ga con " ?ga crlf)
)
(defrule prioridad-ba
  (declare (salience 198)); mas alto que los ingreso-#equipo
  (juega-con ?jugador ?equipo ?campeon)
  ?f0 <- (prioridad (tipo "ba") (champ1 ?campeon) (champ2 ?ba) (flag 0))
  (juega-con ?jug ?equi&~?equipo ?ba) ; no existe el ba en su equipo
  ?f1 <- (campeon (nombre ?campeon) (prioridad ?prioridad))
=>
  (modify ?f0 (flag 1))
  (modify ?f1 (prioridad (+ ?prioridad 1)))
  (printout t "Restando prioridad a " ?campeon " de jugador " ?jugador " y equipo " ?equipo " porque es ba con " ?ba crlf)
)
(defrule ingreso-campeon-fase2
  (declare (salience 199)); mas alto que los ingreso-#equipo
  (con-posicion ?jugador ?equipo ?pos)
=>
  (printout t crlf "Top 3 Campeones Recomendados:" crlf)
  (printout t (implode$ (subseq$ ?*candidatos* 1 3)) crlf)
  (bind ?*candidatos* 0) ; limpiar la lista
  (bind ?*prioridades* 0) ; limpiar la lista
  (printout t "Ingrese nombre del campeon: ")
  (bind ?campeon (readline))
  (assert (juega-con ?jugador ?equipo ?campeon))
  (assert (ban ?campeon)) ; ya no se podra elegir
  (printout t crlf)
)
(defrule ingreso-campeon
  (declare (salience 200)); mas alto que los ingreso-#equipo
  (con-posicion ?jugador ?equipo ?pos)(tiene-codigo ?posicion ?pos)
  (puede-con ?pos $?rols)

  (campeon 
    (nombre ?campeon
      ;&:(not (member ?campeon $?*bans*))
      ;&:()
    )
    (tiene-rols ?r1 ?r2
      &:(or (member ?r1 $?rols)(member ?r2 $?rols))
    )
    (prioridad ?prioridad)
    (ban 0)
  )
  ;(juega-con ? ?&~?nombre)
=>
  (if (integerp ?*candidatos*)
    then
      (bind ?*candidatos* ?*candidatos* ?campeon)
      (bind ?*prioridades* ?*prioridades* ?prioridad)
      (bind ?*candidatos*   (delete$ ?*candidatos*  1 1))
      (bind ?*prioridades*  (delete$ ?*prioridades* 1 1))
      ;(printout t "ELIMINANDO" crlf)
    else ; ingrese ordenado segun prioridad
      (bind ?length (length$ ?*candidatos*))
      (bind ?nswapped True)
      (loop-for-count (?x 1 ?length)
          (bind ?prioridadLista (nth$ ?x ?*prioridades*))
          (if (>= ?prioridad ?prioridadLista)
            then
              ; make the swap happen :)
              (bind ?*candidatos* (insert$ ?*candidatos* ?x ?campeon))
              (bind ?*prioridades* (insert$ ?*prioridades* ?x ?prioridad))
              (bind ?nswapped False)
              ;(printout t "ROMPIENDO" crlf)
              (break)
          )
      )
      (if (eq ?nswapped True)
        then ; anadir al final de la lista
          (bind ?*candidatos* ?*candidatos* ?campeon)
          (bind ?*prioridades* ?*prioridades* ?prioridad)
      )
  )
  ;(printout t crlf "== " ?jugador " == " ?posicion " == " $?rols " == " ?r1 " == " ?r2 " == " ?campeon " == prioridad " ?prioridad  crlf crlf)
)
(defrule ingreso-5m
  (declare (salience 190))
  (jugador 5 "m")
=>
  (printout t crlf "ELECCION DE POSICION" crlf "Posiciones disponibles:" crlf 
    "1. Top" crlf "2. Mid" crlf "3. ADC" crlf "4. Support" crlf "5. Jungle" crlf 
    "Jugador 5 de Equipo Morado, Elija su posicion: ")
  (bind ?pos (read))
  (assert(con-posicion 5 "m" ?pos))
  ;(assert (jugador 5 "m")) ; proximo jugador que elije
)
(defrule ingreso-5a
  (declare (salience 190))
  (jugador 5 "a")
=>
  (printout t crlf "ELECCION DE POSICION" crlf "Posiciones disponibles:" crlf 
    "1. Top" crlf "2. Mid" crlf "3. ADC" crlf "4. Support" crlf "5. Jungle" crlf 
    "Jugador 5 de Equipo Azul, Elija su posicion: ")
  (bind ?pos (read))
  (assert(con-posicion 5 "a" ?pos))
  (assert (jugador 5 "m")) ; proximo jugador que elije
)
(defrule ingreso-4a
  (declare (salience 190))
  (jugador 4 "a")
=>
  (printout t crlf "ELECCION DE POSICION" crlf "Posiciones disponibles:" crlf 
    "1. Top" crlf "2. Mid" crlf "3. ADC" crlf "4. Support" crlf "5. Jungle" crlf 
    "Jugador 4 de Equipo Azul, Elija su posicion: ")
  (bind ?pos (read))
  (assert(con-posicion 4 "a" ?pos))
  (assert (jugador 5 "a")) ; proximo jugador que elije
)
(defrule ingreso-4m
  (declare (salience 190))
  (jugador 4 "m")
=>
  (printout t crlf "ELECCION DE POSICION" crlf "Posiciones disponibles:" crlf 
    "1. Top" crlf "2. Mid" crlf "3. ADC" crlf "4. Support" crlf "5. Jungle" crlf 
    "Jugador 4 de Equipo Morado, Elija su posicion: ")
  (bind ?pos (read))
  (assert(con-posicion 4 "m" ?pos))
  (assert (jugador 4 "a")) ; proximo jugador que elije
)
(defrule ingreso-3m
  (declare (salience 190))
  (jugador 3 "m")
=>
  (printout t crlf "ELECCION DE POSICION" crlf "Posiciones disponibles:" crlf 
    "1. Top" crlf "2. Mid" crlf "3. ADC" crlf "4. Support" crlf "5. Jungle" crlf 
    "Jugador 3 de Equipo Morado, Elija su posicion: ")
  (bind ?pos (read))
  (assert(con-posicion 3 "m" ?pos))
  (assert (jugador 4 "m")) ; proximo jugador que elije
)
(defrule ingreso-3a
  (declare (salience 190))
  (jugador 3 "a")
=>
  (printout t crlf "ELECCION DE POSICION" crlf "Posiciones disponibles:" crlf 
    "1. Top" crlf "2. Mid" crlf "3. ADC" crlf "4. Support" crlf "5. Jungle" crlf 
    "Jugador 3 de Equipo Azul, Elija su posicion: ")
  (bind ?pos (read))
  (assert(con-posicion 3 "a" ?pos))
  (assert (jugador 3 "m")) ; proximo jugador que elije
)
(defrule ingreso-2a
  (declare (salience 190))
  (jugador 2 "a")
=>
  (printout t crlf "ELECCION DE POSICION" crlf "Posiciones disponibles:" crlf 
    "1. Top" crlf "2. Mid" crlf "3. ADC" crlf "4. Support" crlf "5. Jungle" crlf 
    "Jugador 2 de Equipo Azul, Elija su posicion: ")
  (bind ?pos (read))
  (assert(con-posicion 2 "a" ?pos))
  (assert (jugador 3 "a")) ; proximo jugador que elije
)
(defrule ingreso-2m
  (declare (salience 190))
  (jugador 2 "m")
=>
  (printout t crlf "ELECCION DE POSICION" crlf "Posiciones disponibles:" crlf 
    "1. Top" crlf "2. Mid" crlf "3. ADC" crlf "4. Support" crlf "5. Jungle" crlf 
    "Jugador 2 de Equipo Morado, Elija su posicion: ")
  (bind ?pos (read))
  (assert(con-posicion 2 "m" ?pos))
  (assert (jugador 2 "a")) ; proximo jugador que elije
)
(defrule ingreso-1m
  (declare (salience 190))
  (jugador 1 "m")
=>
  (printout t crlf "ELECCION DE POSICION" crlf "Posiciones disponibles:" crlf 
    "1. Top" crlf "2. Mid" crlf "3. ADC" crlf "4. Support" crlf "5. Jungle" crlf 
    "Jugador 1 de Equipo Morado, Elija su posicion: ")
  (bind ?pos (read))
  (assert(con-posicion 1 "m" ?pos))
  (assert (jugador 2 "m")) ; proximo jugador que elije
)
(defrule ingreso-1a
  (declare (salience 190))
  (jugador 1 "a")
=>
  (printout t crlf "ELECCION DE POSICION" crlf "Posiciones disponibles:" crlf 
    "1. Top" crlf "2. Mid" crlf "3. ADC" crlf "4. Support" crlf "5. Jungle" crlf 
    "Jugador 1 de Equipo Azul, Elija su posicion: ")
  (bind ?pos (read))
  (assert (jugador 1 "m")) ; proximo jugador que elije
  (assert(con-posicion 1 "a" ?pos))
)
(defrule trato-ban
(declare (salience 201))
  ?b <- (ban ?campeon)
  ?p <- (campeon (nombre ?campeon) (ban 0))
=>
  (modify ?p (ban 1))
  (retract ?b)
)
(defrule ingreso-informacion1
(declare (salience 201))
   (initial-fact)
=>	
	(printout t "Modo Blind-Pick" crlf)
	
	;(assert (flag201 1))
  (assert (ban "Irelia"))
  (assert (ban "Janna"))
  (assert (ban "Jarvan IV"))
  (assert (ban "Jax"))
  (assert (ban "Jayce"))
  (assert (ban "Jinx"))

	(printout t crlf "Ingrese equipo a pertener, Azul o Morado: ")
	(bind ?*equipo* Azul)

	(printout t crlf "Ingrese el # de jugador (1 - 6) del equipo " ?*equipo* ": ")
	(bind ?*player* 1)
	(printout t crlf)
  (assert (jugador 1 "a")) ; proximo jugador que elije
)
(defrule inicio
(declare (salience 202))
  (initial-fact)
=>
  (load-facts limited_facts.clp)
	(printout t " Exito!!, Se cargaron los datos correctamente" crlf crlf )
)