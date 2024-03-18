extends Spatial

func _ready():
	$CSGTorus.inner_radius = Globals.electron_radius
	$CSGTorus.outer_radius = 1.2 * Globals.electron_radius
