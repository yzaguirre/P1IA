(deftemplate campeon
	(slot nombre (type STRING))
	(slot salud (type INTEGER))
	(slot ataque (type INTEGER))
	(slot hechizo (type INTEGER))
	(slot dificultad (type INTEGER))
	(slot fecha (type STRING))
	(slot puntosip (type INTEGER))
	(slot puntosrp (type INTEGER))
	(slot prioridad (type INTEGER))
)
(defglobal ?*equipo* = 0)
(defglobal ?*player* = 0)
;(defrule efectuar-ban
;	(declare (salience 200))
;	(ban ?ban)
;	?b1 <- (campeon (nombre ?ban)(ban 0))
;=>
;	(modify ?b1 (ban 1))
	;(printout t "efectuando ban: " ?ban crlf)
;)
(defrule ingreso-informacion1
(declare (salience 201))
   (initial-fact)
=>	
	(printout t "Modo Blind-Pick" crlf)
	
	;(assert (flag201 1))
	(printout t "Capitan equipo azul," crlf)
	(printout t "Ingrese nombre de campeon 1 a bannear: ")
	(assert (ban =(readline)))
	
	(printout t crlf "Capitan equipo morado," crlf)
	(printout t "Ingrese nombre de campeon 2 a bannear: ")
	(assert (ban =(readline)))

	(printout t crlf "Capitan equipo azul," crlf)
	(printout t "Ingrese nombre de campeon 3 a bannear: ")
	(assert (ban =(readline)))
	
	(printout t crlf "Capitan equipo morado," crlf)
	(printout t "Ingrese nombre de campeon 4 a bannear: ")
	(assert (ban =(readline)))

	(printout t crlf "Capitan equipo morado," crlf)
	(printout t "Ingrese nombre de campeon 5 a bannear: ")
	(assert (ban =(readline)))

	(printout t crlf "Capitan equipo azul," crlf)
	(printout t "Ingrese nombre de campeon 6 a bannear: ")
	(assert (ban =(readline)))

	(printout t crlf "Ingrese equipo a pertener, Azul o Morado: ")
	(bind ?*equipo* (readline))

	(printout t crlf "Ingrese el # de jugador (1 - 6) del equipo " ?*equipo* ": ")
	(bind ?*player* (readline))
	(assert (ingreso 1))
	(printout t crlf)
)
(defrule inicio
(declare (salience 202))
   (initial-fact)
=>
	(load-facts main_facts.clp)
	;(printout t " Exito!!, Se cargaron los datos correctamente" crlf crlf )
)