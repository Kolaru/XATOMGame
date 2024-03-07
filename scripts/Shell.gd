extends Spatial

export var radius = 4.0
export var thickness = 0.1
export var n_el = 2

var electron_size = 0.4
var bound_electrons = []
var shell = "1s"
var speed = 3

onready var base_color = $Shell.material.albedo_color
onready var Electron = preload("res://scenes/Electron.tscn")

signal selected(shell)
signal deselected(shell)

func _ready():
	$Shell.radius = radius
	
	for el in range(n_el):
		var new_el = Electron.instance()
		var phi = el * 2*PI / n_el
		
		new_el.radius = electron_size / 2
		new_el.phi = phi
		new_el.orbit_radius = radius
		new_el.orbit_speed = speed
		new_el.shell = shell
		
		add_child(new_el)
		
		new_el.connect("hovered", self, "select")
		new_el.connect("unhovered", self, "deselect")
		bound_electrons.push_back(new_el)

func _process(_dt):
	pass
	
func select(from_electron):
	for electron in bound_electrons:
		electron.speed = 0
		
	$Shell.material.albedo_color = Color(1, 1, 1, 0.3)
	emit_signal("selected", self)
	
func deselect(from_electron):
	for electron in bound_electrons:
		electron.speed = electron.orbit_speed
		
	$Shell.material.albedo_color = base_color
	emit_signal("deselected", self)
