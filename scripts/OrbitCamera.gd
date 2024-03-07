# Adapted for Godot 3 from https://github.com/unovafr/Godot-Orbit-Camera
# available under LGPL

extends Camera

# External var
export var SCROLL_SPEED: float = 10 # Speed when use scroll mouse
export var ROTATE_SPEED: float = 10
export var ANCHOR_NODE_PATH: NodePath

# Event var
var _dphi: float
var _dtheta: float
var _scroll_speed: float
var _distance: float

# Transform var
var _position: Vector3
var _anchor_node: Spatial

func _ready():
	_distance = translation.length()
	_position = translation
	_anchor_node = self.get_node(ANCHOR_NODE_PATH)

func _process(delta: float):
	var theta_axis = _position.cross(Vector3.UP)
	_position = _position.rotated(Vector3.UP, _dphi * delta * ROTATE_SPEED)
	_position = _position.rotated(theta_axis.normalized(), _dtheta * delta * ROTATE_SPEED)
	_position = _position.normalized() * _distance
	
	_dphi = 0.0
	_dtheta = 0.0
	
	# Update distance
	_distance += _scroll_speed * delta
	if _distance < 0:
		_distance = 0
	_scroll_speed = 0
	
	translation = _position
	transform = transform.looking_at(_anchor_node.translation, Vector3(0, 1, 0))

func _input(event):
	if event is InputEventMouseMotion:
		_process_mouse_rotation_event(event)
	elif event is InputEventMouseButton:
		_process_mouse_scroll_event(event)

func _process_mouse_rotation_event(e: InputEventMouseMotion):
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		_dphi = -e.relative.x / _distance
		_dtheta = e.relative.y / _distance

func _process_mouse_scroll_event(e: InputEventMouseButton):
	if e.button_index == BUTTON_WHEEL_UP:
		_scroll_speed = -1 * SCROLL_SPEED
	elif e.button_index == BUTTON_WHEEL_DOWN:
		_scroll_speed = 1 * SCROLL_SPEED


