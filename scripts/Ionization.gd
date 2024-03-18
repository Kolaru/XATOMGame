extends Spatial

var original
var photon_energy = 2000

func _ready():
	var origin = original.get_parent().to_global(original.translation)
	original.visible = false
	
	$Electron.translation = origin
	$Electron.velocity = origin.normalized() * sqrt(photon_energy)
