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
	
	var tween = get_tree().create_tween()
	tween.tween_property($Decaying, "translation", destination, 1)
	
	$Photon.shoot(origin, photon_target)

func eject_auger():
	pass
