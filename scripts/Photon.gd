extends Spatial

onready var absorbtion_time = $AnimationPlayer.get_animation("Absorbed").length / $AnimationPlayer.playback_speed
const speed = 80

func shoot(origin, destination):
	$Photon.translation = origin
	$Photon.look_at(destination, Vector3.UP)
	
	var time = (destination - origin).length() / speed
	var tween = get_tree().create_tween()
	tween.tween_property($Photon, "translation", destination, time)
	$AnimationPlayer.play("Emitted")
	$AbsorbtionTimer.wait_time = time - absorbtion_time
	$AbsorbtionTimer.start()

func _on_absorbtion_timer_timeout():
	$AnimationPlayer.play("Absorbed")
