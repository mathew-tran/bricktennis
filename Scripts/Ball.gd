extends RigidBody2D

class_name Ball

var MaxSpeed = 2000
var MinSpeed = 200
var StartPosition = Vector2.ZERO

func _enter_tree():
	$Sprite2D.scale = Vector2.ZERO

func _ready():
	StartPosition = global_position
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2(1,1), .3)
	EventManager.NewRoundInit.connect(OnNewRoundInit)
	EventManager.NewRoundStart.connect(OnNewRoundStart)

func OnNewRoundInit():
	freeze = true
	modulate = Color(20,20,20,.1)
	$CollisionShape2D.disabled = true
	
func OnNewRoundStart():
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", StartPosition, 1.5)
	await tween.finished
	modulate = Color.WHITE
	freeze = false
	$CollisionShape2D.disabled = false

func ShowRacketHitEffect():
	var tween = get_tree().create_tween()
	tween.tween_property($HitEffect, "scale", Vector2.ONE*5, .2)
	await tween.finished
	
	tween = get_tree().create_tween()
	tween.tween_property($HitEffect, "scale", Vector2.ZERO, .1)
	await tween.finished

func _physics_process(delta):
	if linear_velocity.length() > MaxSpeed:
		linear_velocity = linear_velocity.normalized() * MaxSpeed
	elif linear_velocity.length() < MinSpeed:
		linear_velocity = linear_velocity.normalized() * (linear_velocity.length() + delta * 3)

func Hit():
	linear_velocity = linear_velocity.normalized() * (linear_velocity.length() * 1.5)
	
func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is Racket:
		if body.CanHit():
			ShowRacketHitEffect()
			linear_velocity = linear_velocity.normalized() * MaxSpeed
			body.Hit()
	$HitSound.pitch_scale = randf_range(1, 1.2)
	$HitSound.play()
	$Sprite2D.modulate = Color(50,50,50)
	$Sprite2D.scale = Vector2(1.3,1.3)
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2(1,1), .1)
	await tween.finished
	$Sprite2D.modulate = Color.WHITE
