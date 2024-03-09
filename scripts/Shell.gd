extends Spatial

export var radius = 4.0
export var thickness = 0.1
export var n_el = 2

var electron_size = 0.4
var bound_electrons = []
var shell = "1s"
var speed = 3

var is_selected = false
var selected_electron

onready var Electron = preload("res://scenes/Electron.tscn")

signal selected(shell)
signal deselected(shell)

func _ready():
	$Shell.radius = radius
	$SelectedShell.radius = radius
	
	for el in range(n_el):
		var new_el = Electron.instance()
		var phi = el * 2*PI / n_el
		
		new_el.radius = electron_size / 2
		new_el.phi = phi
		new_el.orbit_radius = radius
		new_el.orbit_speed = speed
		new_el.shell = shell
		
		add_child(new_el)
		
		new_el.connect("hovered", self, "_on_hovered")
		new_el.connect("unhovered", self, "_on_unhovered")
		new_el.connect("clicked", self, "_on_clicked")
		bound_electrons.push_back(new_el)

func _process(_dt):
	pass
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		is_selected = false
		deselect_electron()
		deselect()
	
func _on_hovered(from_electron):
	select()
	
func _on_unhovered(from_electron):
	if not is_selected:
		deselect()
	
func _on_clicked(from_electron):
	is_selected = true
	select_electron(from_electron)
	select()
	
func select_electron(electron):
	if selected_electron:
		selected_electron.toggle_outline(false)
	selected_electron = electron
	electron.toggle_outline(true)

func deselect_electron():
	if selected_electron:
		selected_electron.toggle_outline(false)

func select():
	for electron in bound_electrons:
		electron.speed = 0
		
	$Shell.visible = false
	$SelectedShell.visible = true
	emit_signal("selected", self)
	
func deselect():
	for electron in bound_electrons:
		electron.speed = electron.orbit_speed
		
	$Shell.visible = true
	$SelectedShell.visible = false
	emit_signal("deselected", self)
