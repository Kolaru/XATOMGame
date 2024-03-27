extends Spatial

var decaying
var emitted
var hole

var auger_energy = 2000

func start():
	var origin = decaying.get_parent().to_global(decaying.translation)
	var destination = hole.get_parent().to_global(hole.translation)
	var photon_target = emitted.get_parent().to_global(emitted.translation)

	decaying.visible = false
	
	$Decaying.translation = origin
	$Decaying.velocity = origin.normalized() * sqrt(auger_energy)
	
	$Tween.interpolate_property($Decaying, "translation", null, destination, 1)
	$Tween.start()
	
	$Photon.shoot(origin, photon_target)

func eject_auger():
	pass
