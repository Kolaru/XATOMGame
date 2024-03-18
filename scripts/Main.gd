extends Spatial

var photon_energy = 2000
var structure_path = "res://data/structure/iodine.dat"

var selected_shell
var displayed_shell
var shells = {}

onready var Orbit = preload("res://scenes/Shell.tscn")
onready var Electron = preload("res://scenes/Electron.tscn")
onready var Ionization = preload("res://scenes/Ionization.tscn")

func _ready():
	var structure_file = File.new()
	structure_file.open(structure_path, File.READ)
	
	while structure_file.get_position() < structure_file.get_len():
		var line = structure_file.get_csv_line()
		new_orbit(line)

func new_orbit(data):
	var Etot = -float(data[3])
	var Ekin = float(data[4])
	var Epot = Etot + Ekin
	
	var orbit = Orbit.instance()
	shells[data[0]] = orbit
	orbit.shell = data[0]
	orbit.n_el = int(data[1])
	orbit.radius = log(1 + 7e4 / Epot)
	orbit.radius = sqrt(1 + 7e4 / Epot)
	orbit.speed = max(sqrt(Ekin / 1e3), 3)
	
	var theta = rand_range(0, 2*PI)
	var phi = rand_range(0, 2*PI)
	orbit.rotation_axis = Vector3(
		cos(theta) * cos(phi),
		cos(theta) * sin(phi),
		sin(theta)
	)
	orbit.rotation = Vector3(theta, phi, 0)
	
	add_child(orbit)
	
	orbit.connect("toggle_selection", self, "toggle_shell_selection")
	orbit.connect("toggle_highlight", self, "toggle_shell_display")

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
	var target_electron = selected_shell.selected_electron
	var target = selected_shell.to_global(target_electron.translation)
	$Photon.shoot($PhotonSource.translation, target)

func _on_photon_animation_finished(anim_name):
	if anim_name == "Shoot":
		var ionization = Ionization.instance()
		ionization.photon_energy = photon_energy
		ionization.original = selected_shell.selected_electron
		add_child(ionization)

func _on_test_button_pressed():
	$Auger.visible = true
	$Auger.decaying = shells["5p"].bound_electrons[0]
	$Auger.hole = shells["3p"].bound_electrons[0]
	$Auger.emitted = shells["3p"].bound_electrons[0]
	$Auger.start()
