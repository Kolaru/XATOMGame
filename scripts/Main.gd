extends Spatial

var structure_path = "res://data/structure/iodine.dat"
var farfield = 100

onready var Orbit = preload("res://scenes/Shell.tscn")

var selected_shell
var displayed_shell

func new_orbit(data):
	var Etot = -float(data[3])
	var Ekin = float(data[4])
	var Epot = Etot + Ekin
	
	var orbit = Orbit.instance()
	orbit.shell = data[0]
	orbit.n_el = int(data[1])
	orbit.radius = log(1 + 7e4 / Epot)
	orbit.radius = sqrt(1 + 7e4 / Epot)
	orbit.speed = max(sqrt(Ekin / 1e3), 3)
	
	var theta = rand_range(0, 2*PI)
	var phi = rand_range(0, 2*PI)
	
	orbit.rotate(Vector3(0, 0, 1), theta)
	orbit.rotate(Vector3(0, 1, 0), phi)
	
	add_child(orbit)
	
	orbit.connect("toggle_selection", self, "toggle_shell_selection")
	orbit.connect("toggle_highlight", self, "toggle_shell_display")

func _ready():
	var structure_file = File.new()
	structure_file.open(structure_path, File.READ)
	
	while structure_file.get_position() < structure_file.get_len():
		var line = structure_file.get_csv_line()
		new_orbit(line)

func toggle_shell_selection(shell, toggle):
	if toggle:
		selected_shell = shell
	else:
		selected_shell = null
		
	toggle_shell_display(selected_shell, toggle)

func toggle_shell_display(shell, toggle):
	if toggle:
		displayed_shell = shell
	else:
		displayed_shell = null
		shell = selected_shell
	
	if displayed_shell == null and selected_shell == null:
		$Info/Shell.text = "No shell selected"
		$Info/ShootButton.visible = false
	else:
		$Info/Shell.text = "Shell " + shell.shell + " selected"
		$Info/ShootButton.visible = true

func _on_shoot_button_pressed():
	var target = selected_shell.selected_electron.translation
	
	$Photon.translation = selected_shell.to_global(target)
	$Photon/AnimationPlayer.play("Shoot")
	
