extends RigidBody2D

var MoveSpeed = 800
var JetpackSpeed = 300

var MaxSpeed = 950

var bCanShoot = true

enum DIRECTION {
	LEFT,
	RIGHT
}

var DefaultHandRotation = 35
var TargetRotation = 120

var bCanMove = true

@onready var Racket = $Hand/Racket
@onready var PlayerSprite = $Sprite2D
@export var PlayerDirection : DIRECTION

var bIsAlive = true
var bCanBeHurt = true

var StartPosition = Vector2.ZERO

func _ready():
	EventManager.UpdatePlayerHealth.connect(OnUpdatePlayerHealth)
	EventManager.NewRoundStart.connect(OnNewRoundStart)
	StartPosition = global_position

func OnNewRoundStart():
	freeze = true
	bCanBeHurt = false
	$HitCollision.monitoring = false
	modulate = Color(20,20,20,.1)
	var tween = get_tree().create_tween()

	tween.tween_property(self, "global_position", StartPosition, .8)
	var tween2 = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween2.tween_property(self, "rotation_degrees", 360, .8)
	tween.set_trans(Tween.TRANS_QUAD)


	await tween2.finished
	modulate = Color.WHITE
	$HitCollision.monitoring = true
	freeze = false
	bCanBeHurt = true

func OnUpdatePlayerHealth(amount):
	if bIsAlive:
		if amount == 0:
			bIsAlive = false
			EventManager.PlayerDeath.emit()


func _process(delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

	if bIsAlive == false:
		return

	if bCanMove:
		var velocity = Vector2.ZERO


		if Input.is_action_pressed("move_left"):
			velocity.x -= MoveSpeed
			PlayerDirection = DIRECTION.LEFT
			PlayerSprite.rotation_degrees = -10
		elif Input.is_action_pressed("move_right"):
			velocity.x += MoveSpeed
			PlayerDirection = DIRECTION.RIGHT
			PlayerSprite.rotation_degrees = 10
		else:
			PlayerSprite.rotation_degrees = 0

		if Input.is_action_pressed("jetpack"):
			velocity.y -= JetpackSpeed
			$JetParticle.emitting = true

		apply_impulse(velocity *delta * 400)
		UpdateRacket()


func _physics_process(delta):
	var bLeft = linear_velocity.x <= 0
	if abs(linear_velocity.x) > MaxSpeed:
		linear_velocity.x = MaxSpeed
		if bLeft:
			linear_velocity.x = -linear_velocity.x



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
	if bIsAlive == false:
		return

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
	tween.tween_property($Hand, "rotation_degrees", targetDegrees, .25)
	tween.set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	tween = get_tree().create_tween()
	tween.tween_property($Hand, "rotation_degrees", originalDegrees, .05)
	await tween.finished
	bCanShoot = true


func _on_hit_collision_body_entered(body):
	print(body)

	if body is Ball:
		if bCanMove == false:
			return
		if bCanBeHurt == false:
			return
		bCanMove = false
		lock_rotation = false
		modulate = Color.DARK_RED
		EventManager.RewardPoints.emit(5, global_position)
		EventManager.PlayerHit.emit()
		var direction = Vector2.UP

		var sanitizePlayerPosition = global_position
		direction = (global_position - body.global_position).normalized()
		direction = SanitizeDirection(direction)
		apply_impulse(direction * MoveSpeed * 40)
		if direction == Vector2.RIGHT:
			angular_velocity += 10
		else:
			angular_velocity -= 10
		var timer = get_tree().create_timer(randf_range(.8, 1.2))

		await timer.timeout

		if bIsAlive:
			lock_rotation = true
			var tween = get_tree().create_tween()
			tween.tween_property(self, "rotation_degrees", 0, .1)
			await tween.finished
			bCanMove = true
			modulate = Color.WHITE
		else:
			self_modulate = Color.BLACK

func SanitizeDirection(vector: Vector2) -> Vector2:
		if vector.x > 0:
			return Vector2.RIGHT  # Right
		else:
			return Vector2.LEFT  # Left

