extends RigidBody2D

class_name Racket

var bIsStrengthened = false

func SetCollisionEnabled(bEnable):
	$CollisionShape2D.set_deferred("disabled", !bEnable)

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

func HasStrengthened():
	return bIsStrengthened
	
func SetIncreasedStrength(bTrue):
	bIsStrengthened = bTrue
