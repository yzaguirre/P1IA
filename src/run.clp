(deftemplate campeon
	(slot nombre (type STRING))
	(slot primario (type STRING))
	(slot secundario (type STRING))
	(slot salud (type INTEGER))
	(slot ataque (type INTEGER))
	(slot hechizo (type INTEGER))
	(slot dificultad (type INTEGER))
	(slot fecha (type STRING))
	(slot puntosip (type INTEGER))
	(slot puntosrp (type INTEGER))
	(slot prioridad (type INTEGER))
	(multislot ga)
	(multislot ba)
	(multislot gw)
	(slot ban (type INTEGER))
)
; Aatrox
(defglobal ?*op1* = 0)
(defglobal ?*op2* = 0)
(defglobal ?*op3* = 0)
(defglobal ?*equipo* = 0)
(defglobal ?*player* = 0)
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

;(defrule analisis-ingreso-jugador
;	(declare (salience 187))
;	?p <- (juega-con ?jA ?campeon)
;	(juega-con ?jX ?campeon)
;=>
	;(printout t "Campeon " ?campeon " ya pertenece a jugador " ?jX)
;)
;(defrule ingreso-jugador1a
;(declare (salience 200))
	;(initial-fact)
;
	;(not (juega-con ?* ?*op1*))
;
;	(not (juega-con ?* ?*op2*))
;
;	(not (juega-con ?* ?*op3*))
;=>
;	(printout t "Jugador 1 equipo azul, estas son tus 3 recomendaciones de campeon: " crlf)
;	()
	;(bind ?campeon (readline))
	;(assert (juega-con "1a" ?campeon))
;)
;analisar rol
;no banneado (ban ?campeon)
;no elegido (juega-con ?x ?campeon)
;ordenarlos segun prioridad
;top 3
;assert juega-con j1a campeon
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
(defrule ingreso-campeon
  (declare (salience 200)); mas alto que los ingreso-#equipo
  (con-posicion ?j ?pos)
  (tiene-codigo ?posicion ?pos)
  (puede-con ?pos ?rol)
  ;not (ban ?nombre)
  ;not (juega-con ?j ?nombre)
  
  ;(campeon (?nombre)(primario ?rol)) Or (campeon (secundario ?rol))
  ;(order by prioridad)
  ;(top tres)
=>
  (printout t crlf "== " ?j " == " ?posicion " == " ?rol " ==" crlf crlf)
  ;(juega-con ?j ?nombre)
)
(defrule ingreso-5m
  (declare (salience 199))
  (jugador "5m")
=>
  (printout t crlf "ELECCION DE POSICION" crlf "Posiciones disponibles:" crlf 
    "1. Top" crlf "2. Mid" crlf "3. ADC" crlf "4. Support" crlf "5. Jungle" crlf 
    "Jugador 5 de Equipo Morado, Elija su posicion: ")
  (bind ?pos (read))
  (assert(con-posicion "5m" ?pos))
  ;(assert (jugador "5m")) ; proximo jugador que elije
)
(defrule ingreso-5a
  (declare (salience 199))
  (jugador "5a")
=>
  (printout t crlf "ELECCION DE POSICION" crlf "Posiciones disponibles:" crlf 
    "1. Top" crlf "2. Mid" crlf "3. ADC" crlf "4. Support" crlf "5. Jungle" crlf 
    "Jugador 5 de Equipo Azul, Elija su posicion: ")
  (bind ?pos (read))
  (assert(con-posicion "5a" ?pos))
  (assert (jugador "5m")) ; proximo jugador que elije
)
(defrule ingreso-4a
  (declare (salience 199))
  (jugador "4a")
=>
  (printout t crlf "ELECCION DE POSICION" crlf "Posiciones disponibles:" crlf 
    "1. Top" crlf "2. Mid" crlf "3. ADC" crlf "4. Support" crlf "5. Jungle" crlf 
    "Jugador 4 de Equipo Azul, Elija su posicion: ")
  (bind ?pos (read))
  (assert(con-posicion "4a" ?pos))
  (assert (jugador "5a")) ; proximo jugador que elije
)
(defrule ingreso-4m
  (declare (salience 199))
  (jugador "4m")
=>
  (printout t crlf "ELECCION DE POSICION" crlf "Posiciones disponibles:" crlf 
    "1. Top" crlf "2. Mid" crlf "3. ADC" crlf "4. Support" crlf "5. Jungle" crlf 
    "Jugador 4 de Equipo Morado, Elija su posicion: ")
  (bind ?pos (read))
  (assert(con-posicion "4m" ?pos))
  (assert (jugador "4a")) ; proximo jugador que elije
)
(defrule ingreso-3m
  (declare (salience 199))
  (jugador "3m")
=>
  (printout t crlf "ELECCION DE POSICION" crlf "Posiciones disponibles:" crlf 
    "1. Top" crlf "2. Mid" crlf "3. ADC" crlf "4. Support" crlf "5. Jungle" crlf 
    "Jugador 3 de Equipo Morado, Elija su posicion: ")
  (bind ?pos (read))
  (assert(con-posicion "3m" ?pos))
  (assert (jugador "4m")) ; proximo jugador que elije
)
(defrule ingreso-3a
  (declare (salience 199))
  (jugador "3a")
=>
  (printout t crlf "ELECCION DE POSICION" crlf "Posiciones disponibles:" crlf 
    "1. Top" crlf "2. Mid" crlf "3. ADC" crlf "4. Support" crlf "5. Jungle" crlf 
    "Jugador 3 de Equipo Azul, Elija su posicion: ")
  (bind ?pos (read))
  (assert(con-posicion "3a" ?pos))
  (assert (jugador "3m")) ; proximo jugador que elije
)
(defrule ingreso-2a
  (declare (salience 199))
  (jugador "2a")
=>
  (printout t crlf "ELECCION DE POSICION" crlf "Posiciones disponibles:" crlf 
    "1. Top" crlf "2. Mid" crlf "3. ADC" crlf "4. Support" crlf "5. Jungle" crlf 
    "Jugador 2 de Equipo Azul, Elija su posicion: ")
  (bind ?pos (read))
  (assert(con-posicion "2a" ?pos))
  (assert (jugador "3a")) ; proximo jugador que elije
)
(defrule ingreso-2m
  (declare (salience 199))
  (jugador "2m")
=>
  (printout t crlf "ELECCION DE POSICION" crlf "Posiciones disponibles:" crlf 
    "1. Top" crlf "2. Mid" crlf "3. ADC" crlf "4. Support" crlf "5. Jungle" crlf 
    "Jugador 2 de Equipo Morado, Elija su posicion: ")
  (bind ?pos (read))
  (assert(con-posicion "2m" ?pos))
  (assert (jugador "2a")) ; proximo jugador que elije
)
(defrule ingreso-1m
  (declare (salience 199))
  (jugador "1m")
=>
  (printout t crlf "ELECCION DE POSICION" crlf "Posiciones disponibles:" crlf 
    "1. Top" crlf "2. Mid" crlf "3. ADC" crlf "4. Support" crlf "5. Jungle" crlf 
    "Jugador 1 de Equipo Morado, Elija su posicion: ")
  (bind ?pos (read))
  (assert(con-posicion "1m" ?pos))
  (assert (jugador "2m")) ; proximo jugador que elije
)
(defrule ingreso-1a
  (declare (salience 199))
  (jugador "1a")
=>
  (printout t crlf "ELECCION DE POSICION" crlf "Posiciones disponibles:" crlf 
    "1. Top" crlf "2. Mid" crlf "3. ADC" crlf "4. Support" crlf "5. Jungle" crlf 
    "Jugador 1 de Equipo Azul, Elija su posicion: ")
  (bind ?pos (read))
  (assert (jugador "1m")) ; proximo jugador que elije
  (assert(con-posicion "1a" ?pos))
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
	(bind ?*equipo* (readline))

	(printout t crlf "Ingrese el # de jugador (1 - 6) del equipo " ?*equipo* ": ")
	(bind ?*player* (read))
	(printout t crlf)
  (assert (jugador "1a")) ; proximo jugador que elije
)
(defrule inicio
(declare (salience 202))
  (initial-fact)
=>
  (load-facts run_facts.clp)
	(printout t " Exito!!, Se cargaron los datos correctamente" crlf crlf )
)