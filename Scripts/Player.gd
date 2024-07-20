extends RigidBody2D

var MoveSpeed = 80000

var MaxSpeed = 600

var bCanShoot = true

enum DIRECTION {
	LEFT,
	RIGHT
}

var DefaultHandRotation = 45
var TargetRotation = 120
@onready var Racket = $Hand/Racket
@onready var PlayerSprite = $Sprite2D
@export var PlayerDirection : DIRECTION
func _process(delta):
	var velocity = Vector2.ZERO

	if Input.is_action_pressed("move_left"):
		velocity.x -= MoveSpeed
		PlayerDirection = DIRECTION.LEFT

	if Input.is_action_pressed("move_right"):
		velocity.x += MoveSpeed
		PlayerDirection = DIRECTION.RIGHT

	apply_impulse(velocity *delta)

	var bLeft = linear_velocity.x <= 0
	if abs(linear_velocity.x) > MaxSpeed:
		linear_velocity.x = MaxSpeed
		if bLeft:
			linear_velocity.x = -linear_velocity.x
	UpdateRacket()


func UpdateRacket():
	if bCanShoot:
		match PlayerDirection:
			DIRECTION.LEFT:
				$Hand.scale = Vector2(-1,1)
				$Hand.rotation_degrees = -DefaultHandRotation
				PlayerSprite.flip_h = true
			DIRECTION.RIGHT:
				$Hand.scale = Vector2(1,1)
				$Hand.rotation_degrees = DefaultHandRotation
				PlayerSprite.flip_h = false
func _input(event):
	if event.is_action_released("shoot"):
		MoveRacket()

func MoveRacket():
	if bCanShoot == false:
		return
	bCanShoot = false
	var targetDegrees = TargetRotation
	var originalDegrees = $Hand.rotation_degrees
	if PlayerDirection == DIRECTION.RIGHT:
		targetDegrees = -targetDegrees

	var tween = get_tree().create_tween()
	tween.tween_property($Hand, "rotation_degrees", targetDegrees, .3)
	tween.set_trans(Tween.TRANS_LINEAR)
	await tween.finished
	tween = get_tree().create_tween()
	tween.tween_property($Hand, "rotation_degrees", originalDegrees, .1)
	await tween.finished
	bCanShoot = true
