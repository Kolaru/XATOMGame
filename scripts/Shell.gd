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
onready var subshell = shell[1]

signal toggle_selection(shell, toggle)
signal toggle_highlight(shell, toggle)

const subshell_sizes = {"s": 2, "p": 6, "d": 10, "f": 14}

func _ready():
	$Shell.radius = radius
	$SelectedShell.radius = radius
	
	for el in range(subshell_sizes[subshell]):
		var phi = el * 2*PI / subshell_sizes[subshell]
		var position = radius * Vector3(cos(phi), 0, sin(phi))
		var hole = Hole.instance()
		hole.translation = position
		hole.hole_size = electron_size
		hole.rotation = Vector3(0, -phi, 0)
		add_child(hole)
		
		if el < n_el:
			var electron = Electron.instance()
			electron.translation = position
			electron.radius = electron_size
			add_child(electron)
			electron.connect("hovered", self, "_on_hovered")
			electron.connect("unhovered", self, "_on_unhovered")
			electron.connect("clicked", self, "_on_clicked")
			bound_electrons.push_back(electron)

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
