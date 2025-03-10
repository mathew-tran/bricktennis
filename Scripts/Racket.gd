extends RigidBody2D

class_name Racket

var bIsStrengthened = false
var bCanHit = true

func SetCollisionEnabled(bEnable):
	$CollisionShape2D.set_deferred("disabled", !bEnable)

func Hit():
	EventManager.RewardPoints.emit(1, global_position)
	if CanHit() == false:
		return
	bCanHit = false
	
	var tween = get_tree().create_tween()
	var result = randi() % 2
	var target = -2
	if result == 0:
		target = -target
	
	tween.tween_property($Sprite2D, "rotation_degrees", target, .1)
	await tween.finished
	tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "rotation_degrees", 0, .01)
	await tween.finished
	$AudioStreamPlayer2D.play()
	bCanHit = true
	$Timer.start()
	SetCollisionEnabled(false)

func _on_timer_timeout():
	SetCollisionEnabled(true)
	
func CanHit():
	return $CollisionShape2D.disabled == false and bCanHit

func HasStrengthened():
	return bIsStrengthened
	
func SetIncreasedStrength(bTrue):
	bIsStrengthened = bTrue
