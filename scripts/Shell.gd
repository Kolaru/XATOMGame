extends Spatial

export var radius = 4.0
export var thickness = 0.1
export var n_el = 2

var rotation_axis = Vector3(0, 1, 0)
var electron_size = 0.6
var bound_electrons = []
var shell = "1s"
var speed = 4

enum State {IDLE, HOVERED, SELECTED}
var state = State.IDLE
var selected_electron

onready var Electron = preload("res://scenes/Electron.tscn")
onready var Hole = preload("res://scenes/Hole.tscn")

signal toggle_selection(shell, toggle)
signal toggle_highlight(shell, toggle)

func _ready():
	$Shell.radius = radius
	$SelectedShell.radius = radius
	
	for el in range(n_el):
		var phi = el * 2*PI / n_el
		var new_el = Electron.instance()
		
		# new_el.translation = Vector3(radius, 0, 0).rotated(rotation_axis, phi)
		new_el.translation = radius * Vector3(cos(phi), 0, sin(phi))
		new_el.radius = electron_size
		add_child(new_el)
		
		new_el.connect("hovered", self, "_on_hovered")
		new_el.connect("unhovered", self, "_on_unhovered")
		new_el.connect("clicked", self, "_on_clicked")
		bound_electrons.push_back(new_el)

func _process(dt):
	if state == State.IDLE:
		var dphi = dt * speed / radius
		rotate_object_local(Vector3(0, 1, 0), dphi)

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
	$Shell.visible = false
	$SelectedShell.visible = true
	
func dehighlight():
	$Shell.visible = true
	$SelectedShell.visible = false
