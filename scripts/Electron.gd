extends CSGSphere

var state = "bound"

# Bound electron
var orbit_speed = 3
var shell:String
var orbit_radius = 4
var phi = 0

# Free electron
var velocity = Vector3.ZERO

var outlined = false

signal hovered(electron)
signal unhovered(electron)
signal clicked(electron)

onready var speed = orbit_speed
onready var Outline = preload("res://addons/3D Outline/Outline.material")

func _ready():
	$Area/Shape.shape.radius = 2*radius

func _process(dt):
	if state == "bound":
		phi += dt * speed / orbit_radius
		translation = orbit_radius * Vector3(cos(phi), 0, sin(phi))
		$Trace.draw_pass_1.radius = radius * 0.6
		$Trace.draw_pass_1.height = 2*$Trace.draw_pass_1.radius
	elif state == "free":
		pass

func _input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position, " shape:", shape_idx)

func _on_mouse_entered():
	emit_signal("hovered", self)
	toggle_outline(true)
	
func _on_mouse_exited():
	emit_signal("unhovered", self)
	toggle_outline(false)

func toggle_outline(value):
	material.next_pass.set_shader_param("enable", value)
	$Trace.draw_pass_1.material.next_pass.set_shader_param("enable", value)

func _on_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		print("Clicked")
