extends Spatial

var hole_size = 0.8

func _ready():
	$CSGTorus.inner_radius = hole_size
	$CSGTorus.outer_radius = 1.2 * hole_size
