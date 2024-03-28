extends Spatial

onready var absorbtion_time = $AnimationPlayer.get_animation("Absorbed").length / $AnimationPlayer.playback_speed
const speed = 80

signal absorbed(photon)

func shoot(origin, destination):
	$Photon.translation = origin
	$Photon.look_at(destination, Vector3.UP)
	
	var time = (destination - origin).length() / speed
	
	$Tween.interpolate_property($Photon, "translation", null, destination, time)
	$Tween.start()
	
	$AnimationPlayer.play("Emitted")
	$AbsorbtionTimer.wait_time = time - absorbtion_time
	$AbsorbtionTimer.start()
	

func _on_absorbtion_timer_timeout():
	$AnimationPlayer.play("Absorbed")

func _on_absorbtion_completed():
	emit_signal("absorbed", self)
