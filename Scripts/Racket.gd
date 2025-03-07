extends RigidBody2D

class_name Racket

func SetCollisionEnabled(bEnable):
	$CollisionShape2D.disabled = !bEnable

func Hit():
	if CanHit() == false:
		return
	$AudioStreamPlayer2D.play()
	$Timer.start()
	SetCollisionEnabled(false)

func _on_timer_timeout():
	SetCollisionEnabled(true)
	
func CanHit():
	return $CollisionShape2D.disabled == false
