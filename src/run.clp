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
  (multislot ga)
  (multislot ba)
  (multislot gw)
  (slot ban (type INTEGER))
)
(deftemplate prioridad
  (slot tipo (type STRING))
  (slot champ1 (type STRING))
  (slot champ2 (type STRING))
  (slot flag (type INTEGER))
)
; Aatrox
(defglobal ?*equipo* = 0) ; equipo que pertenece a la defglobal player de abajo que representa al usuario
(defglobal ?*player* = 0) ; eleccion de # jugador que representa al usuario
(defglobal ?*candidatos* = 0) ; lista de candidatos ordenado segun prioridad de la lista de abajo
(defglobal ?*prioridades* = 0) ; lista de prioridades de campeones de arriba en orden descendente

(defglobal ?*campeones* = 0) ; lista de jugadores elegidos ordenado segun reglas de elección de campeon
(defglobal ?*equipos* = 0) ; equipo que pertenece el jugador que elegio el campeon en la lista de arriba

(defrule como-le-fue
(declare (salience 186))
  (juega-con ?player ?equipo ?campeon)
  (test (and (eq ?player ?*player*) (eq ?equipo ?*equipo*)))
  ?p <- (campeon (nombre ?campeon) (prioridad ?prioridad) (ban 1))
=>
	(printout t crlf "Ud. es el jugador #" ?*player* " del equipo " ?*equipo* ". " crlf "Con prioridad igual a " ?prioridad ", le fue bien a tu campeon \"" ?campeon "\" ? si o no: ")
	(bind ?comolefue (readline))
  (open "prioridad.txt" escritura "a")
  (if (eq ?comolefue "si")
    then (modify ?p (prioridad (+ ?prioridad 1))(ban 2)) (printout escritura "\"" ?campeon "\" \"1\"" crlf)
    else (modify ?p (prioridad (- ?prioridad 1))(ban 2)) (printout escritura "\"" ?campeon "\" \"0\"" crlf)
  )
  (printout t "Guardando... Listo" crlf)
  (close)
)
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
  (if (integerp ?*campeones*)
    then ; eliminar el campo 0
      (bind ?*campeones* ?*campeones* ?campeon)
      (bind ?*equipos* ?*equipos* ?equipo)
      (bind ?*campeones*   (delete$ ?*campeones*  1 1))
      (bind ?*equipos*  (delete$ ?*equipos* 1 1))
    else ; ingreso normal
      (bind ?*campeones* ?*campeones* ?campeon)
      (bind ?*equipos* ?*equipos* ?equipo)
  )
  (assert (ban ?campeon)) ; ya no se podra elegir
  (printout t crlf)
)
(defrule ingreso-campeon
  (declare (salience 200)); mas alto que los ingreso-#equipo
  (con-posicion ?jugador ?equipo ?pos)(tiene-codigo ?posicion ?pos)
  (puede-con ?pos $?rols)

  (campeon 
    (nombre ?campeon)
    (tiene-rols ?r1 ?r2
      &:(or (member ?r1 $?rols)(member ?r2 $?rols))
    )
    (prioridad ?prioridad)
    (gw $?allgw)
    (ga $?allga)
    (ba $?allba)
    (ban 0)
  )
=>
  (if (integerp ?*candidatos*)
    then
      (bind ?*candidatos* ?*candidatos* ?campeon)
      (bind ?*prioridades* ?*prioridades* ?prioridad)
      (bind ?*candidatos*   (delete$ ?*candidatos*  1 1))
      (bind ?*prioridades*  (delete$ ?*prioridades* 1 1))
      ;(printout t "ELIMINANDO" crlf)
    else ; ingrese ordenado segun prioridad
      ; antes, modificar prioridad a causa de campeones elegidos anteriormente
      (bind ?pri ?prioridad); la prioridad a modificar del candidato
      (if (not (integerp ?*campeones*)) ; por lo menos ya se ha elegido el primer campeon
        then
          (bind ?len (length$ ?*campeones*))
          (loop-for-count (?a 1 ?len); iterar los campeones ya elegidos (maximo 9)
            (bind ?chosenChamp (nth$ ?a ?*campeones*)) ; nombre de campeon elegido
            (bind ?chosenTeam (nth$ ?a ?*equipos*)) ; equipo que elegio el campeon
            (loop-for-count (?i 1 10); iterar por gw ga ba del campeon candidato
              (bind ?igw (nth$ ?i $?allgw))
              (bind ?iga (nth$ ?i $?allga))
              (bind ?iba (nth$ ?i $?allba))
              
              (if (and (eq ?igw ?chosenChamp)(eq ?chosenTeam ?equipo))
                then (bind ?pri (+ ?pri 1)); sumar prioridad
                ;(printout t "sumando gw" crlf)
                else 
                  (if (and (eq ?iga ?chosenChamp)(neq ?chosenTeam ?equipo))
                    then (bind ?pri (+ ?pri 1)); sumar prioridad
                      ;(printout t "sumando ga" crlf)
                    else 
                      (if (and (eq ?iba ?chosenChamp)(neq ?chosenTeam ?equipo))
                        then (bind ?pri (- ?pri 1)); restar prioridad
                        ;(printout t "sumando ba" crlf)
                      )
                  )
              )
            )
          )
      )
      ; ahora si, el ingreso ordenado
      (bind ?length (length$ ?*candidatos*))
      (bind ?nswapped True)
      (loop-for-count (?x 1 ?length)
          (bind ?prioridadLista (nth$ ?x ?*prioridades*))
          (if (>= ?pri ?prioridadLista)
            then
              ; make the swap happen :)
              (bind ?*candidatos* (insert$ ?*candidatos* ?x ?campeon))
              (bind ?*prioridades* (insert$ ?*prioridades* ?x ?pri))
              (bind ?nswapped False)
              ;(printout t "ROMPIENDO" crlf)
              (break)
          )
      )
      (if (eq ?nswapped True)
        then ; anadir al final de la lista
          (bind ?*candidatos* ?*candidatos* ?campeon)
          (bind ?*prioridades* ?*prioridades* ?pri)
      )
  )
  ;(printout t crlf "== " ?jugador " == " ?posicion " == " $?rols " == " ?r1 " == " ?r2 " == " ?campeon " == prioridad " ?pri  crlf crlf)
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
	
  (assert (ban "Irelia"))
  (assert (ban "Janna"))
  (assert (ban "Jarvan IV"))
  (assert (ban "Jax"))
  (assert (ban "Jayce"))
  (assert (ban "Jinx"))

	(printout t crlf "Ingrese equipo a pertener, azul o morado: ")
	(bind ?*equipo* "a")

	(printout t crlf "Ingrese el # de jugador (1 - 6) del equipo " ?*equipo* ": ")
	(bind ?*player* 1)
	(printout t crlf)
  (assert (jugador 1 "a")) ; proximo jugador que elije
)
(defrule regla-lectura
  (declare (salience 202))
  (initial-fact)
  ?f0 <- (reemplaza-priori ?campeon ?prioridad)
  ?f1 <- (campeon (nombre ?campeon) (prioridad ?pri))
=>
  (retract ?f0)
  (printout t "MODIFICANDO prioridad de " ?pri " de " ?campeon " con: ")
  (if (eq "1" ?prioridad)
    then
      (modify ?f1 (prioridad (+ 1 ?pri)))
      (printout t "+1" crlf)
    else
      (modify ?f1 (prioridad (- 1 ?pri)))
      (printout t "-1" crlf)
  )
)
(defrule inicio
(declare (salience 203))
  (initial-fact)
=>
  (load-facts limited_facts.clp)
  (open "prioridad.txt" lectura "r")
  (bind ?campeon (read lectura))
  (bind ?prioridad (read lectura))
  (while (neq ?campeon EOF)
    (assert (reemplaza-priori ?campeon ?prioridad))
    ;(printout t "campeon encontrado " ?campeon " y prioridad defecto " ?prioridad crlf)
    (bind ?campeon (read lectura))
    (bind ?prioridad (read lectura))
  )
  (close)
	;(printout t " Exito!!, Se cargaron los datos correctamente" crlf crlf )
)