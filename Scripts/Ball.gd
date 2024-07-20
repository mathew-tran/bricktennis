extends RigidBody2D

class_name Ball

var MaxSpeed = 2500

func _enter_tree():
	$Sprite2D.scale = Vector2.ZERO

func _ready():

	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2(1,1), .3)

# Called when the node enters the scene tree for the first time.


func _physics_process(delta):
	if linear_velocity.length() > MaxSpeed:
		linear_velocity = linear_velocity.normalized() * MaxSpeed

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	$Sprite2D.modulate = Color(50,50,50)
	$Sprite2D.scale = Vector2(1.3,1.3)
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2(1,1), .1)
	await tween.finished
	$Sprite2D.modulate = Color.WHITE
