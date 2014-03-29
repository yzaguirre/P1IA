(deftemplate campeon
	(slot nombre)
	(slot primario)
	(slot secundario)
	(slot salud)
	(slot ataque)
	(slot hechizo)
	(slot dificultad)
	(slot fecha)
	(slot puntosip)
	(slot puntosrp)
)
;<td>(.*)<td>(.*)<td>(.*)<td>(.*)<td>(.*)<td>(.*)<td>(.*)<td>(.*)<td>(.*)<td>(.*)\)$
;(nombre "$1")\n(primario "$2")\n(secundario "$3")\n(salud "$4")\n(ataque "$5")\n(hechizo "$6")\n(dificultad "$7")\n(fecha "$8")\n(puntosip "$9")\n(puntosrp "$10")\n)