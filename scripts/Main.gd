extends Spatial

var structure_path = "res://data/structure/iodine.dat"

onready var Orbit = preload("res://scenes/Shell.tscn")

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
	
	orbit.connect("selected", self, "select_shell")
	orbit.connect("deselected", self, "deselect_shell")

func _ready():
	var structure_file = File.new()
	structure_file.open(structure_path, File.READ)
	
	while structure_file.get_position() < structure_file.get_len():
		var line = structure_file.get_csv_line()
		new_orbit(line)

func select_shell(shell):
	$Info/Shell.text = "Shell " + shell.shell + " selected"
	
func deselect_shell(shell):
	$Info/Shell.text = "No shell selected"
