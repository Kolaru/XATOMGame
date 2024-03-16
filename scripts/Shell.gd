extends Spatial

export var radius = 4.0
export var thickness = 0.1
export var n_el = 2

var electron_size = 0.8
var bound_electrons = []
var shell = "1s"
var speed = 4

enum State {IDLE, HOVERED, SELECTED}
var state = State.IDLE
var selected_electron

onready var Electron = preload("res://scenes/Electron.tscn")

signal toggle_selection(shell, toggle)
signal toggle_highlight(shell, toggle)

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
	
func _on_clicked(from_electron):
	state = State.SELECTED
	select_electron(from_electron)
	highlight()
	emit_signal("toggle_selection", self, true)
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		state = State.IDLE
		deselect_electron()
		dehighlight()
		emit_signal("toggle_selection", self, false)
	
func _on_hovered(from_electron):
	if state == State.IDLE:
		state = State.HOVERED
		highlight()
		emit_signal("toggle_highlight", self, true)
	
func _on_unhovered(from_electron):
	if state == State.HOVERED && state != State.SELECTED:
		state = State.IDLE
		dehighlight()
		emit_signal("toggle_highlight", self, false)
	
func select_electron(electron):
	if selected_electron:
		selected_electron.toggle_outline(false)
	selected_electron = electron
	electron.toggle_outline(true)

func deselect_electron():
	if selected_electron:
		selected_electron.toggle_outline(false)

func highlight():
	for electron in bound_electrons:
		electron.speed = 0
		
	$Shell.visible = false
	$SelectedShell.visible = true
	
func dehighlight():
	for electron in bound_electrons:
		electron.speed = electron.orbit_speed
		
	$Shell.visible = true
	$SelectedShell.visible = false
