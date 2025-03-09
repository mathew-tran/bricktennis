extends RigidBody2D

class_name Player

var MoveSpeed = 400
var JetpackSpeed = 300

var MaxSpeed = 950

var bCanShoot = true

enum DIRECTION {
	LEFT,
	RIGHT
}

var DefaultHandRotation = 15


var bCanMove = true

@onready var PlayerRacket = $Hand/Racket
@onready var PlayerSprite = $Sprite2D
@export var PlayerDirection : DIRECTION

var bIsAlive = true
var bCanBeHurt = true

var StartPosition = Vector2.ZERO

func _ready():
	EventManager.UpdatePlayerHealth.connect(OnUpdatePlayerHealth)
	EventManager.NewRoundStart.connect(OnNewRoundStart)
	StartPosition = global_position
	PlayerDirection = DIRECTION.RIGHT
	
func OnNewRoundStart():
	freeze = true
	
	$Sprite2D/HappyFace.visible = true
	bCanBeHurt = false
	$HitCollision.monitoring = false
	modulate = Color(20,20,20,.1)
	var tween = get_tree().create_tween()

	tween.tween_property(self, "global_position", StartPosition, .8)
	var tween2 = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween2.tween_property(self, "rotation_degrees", 360, .8)
	tween.set_trans(Tween.TRANS_QUAD)

	PlayerDirection = DIRECTION.RIGHT
	UpdateRacket(true)
	await tween2.finished
	modulate = Color.WHITE
	$HitCollision.monitoring = true
	freeze = false


	var timer = get_tree().create_timer(1)
	$HappySound.pitch_scale = randf_range(.9, 1.2)
	$HappySound.play()
	await timer.timeout
	$Sprite2D/HappyFace.visible = false
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

	if bCanShoot == false:
		PlayerSprite.rotation_degrees = $Hand.rotation_degrees * 1.2
	if bCanMove and bCanShoot:
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
			PlayJetpackSound()

		if velocity != Vector2.ZERO:
			$Sprite2D/ThinkingFace.visible = true
		else:
			$Sprite2D/ThinkingFace.visible = false

		apply_impulse(velocity *delta * 400)
		UpdateRacket()

func PlayJetpackSound():
	if $JetpackSound.playing == false:
		$JetpackSound.pitch_scale = randf_range(1.0,1.2)
		$JetpackSound.play()

func _physics_process(delta):
	var bLeft = linear_velocity.x <= 0
	if abs(linear_velocity.x) > MaxSpeed:
		linear_velocity.x = MaxSpeed
		if bLeft:
			linear_velocity.x = -linear_velocity.x



func UpdateRacket(bForce = false):
	if bCanShoot or bForce:
		match PlayerDirection:
			DIRECTION.LEFT:
				$Hand.scale = Vector2(-1,1)
				$Hand.rotation_degrees = -DefaultHandRotation
				PlayerSprite.flip_h = true
				$Sprite2D/HurtFace.offset.x = -6
				$Sprite2D/HappyFace.offset.x = -6
				$Sprite2D/ThinkingFace.offset.x = -6
			DIRECTION.RIGHT:
				$Hand.scale = Vector2(1,1)
				$Hand.rotation_degrees = DefaultHandRotation
				PlayerSprite.flip_h = false
				$Sprite2D/HurtFace.offset.x = 6
				$Sprite2D/HappyFace.offset.x = 6
				$Sprite2D/ThinkingFace.offset.x = 6




func _input(event):
	if bIsAlive == false or bCanShoot == false:
		return

	if bCanShoot:
		if event.is_action_released("shoot"):
			MoveRacket()
		elif event.is_action_pressed("right_click"):
			BlockRacket()

func MoveRacket():
	if bCanShoot == false:
		return
	bCanShoot = false
	var targetDegrees = 60
	var originalDegrees = $Hand.rotation_degrees
	if PlayerDirection == DIRECTION.RIGHT:
		targetDegrees = -targetDegrees

	$SwingSound.pitch_scale = randf_range(1.0,1.2)
	$SwingSound.play()
	var tween = get_tree().create_tween()
	tween.tween_property($Hand, "rotation_degrees", targetDegrees, .10)
	tween.set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	tween = get_tree().create_tween()
	tween.tween_property($Hand, "rotation_degrees", originalDegrees, .1)
	await tween.finished
	bCanShoot = true

func BlockRacket():
	if bCanShoot == false:
		return
	bCanShoot = false
	var targetDegrees = 360
	var originalDegrees = $Hand.rotation_degrees
	if PlayerDirection == DIRECTION.RIGHT:
		targetDegrees = -targetDegrees

	$SwingSound.pitch_scale = randf_range(1.0,1.2)
	$SwingSound.play()
	var tween = get_tree().create_tween()
	PlayerRacket.SetIncreasedStrength(true)
	tween.tween_property($Hand, "rotation_degrees", targetDegrees, .30)
	tween.set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	tween = get_tree().create_tween()
	tween.tween_property($Hand, "rotation_degrees", originalDegrees, .1)
	PlayerRacket.SetIncreasedStrength(false)
	
	await tween.finished
	tween = get_tree().create_tween()
	tween.tween_property($Hand, "rotation_degrees", 0, 1.0)
	await tween.finished
	bCanShoot = true
	

func _on_hit_collision_body_entered(body):
	pass

	if body is Ball:
		if bCanMove == false:
			return
		if bCanBeHurt == false:
			return
		$HitSound.pitch_scale = randf_range(0.9, 1.2)
		$HitSound.play()
		bCanMove = false
		$Sprite2D/HurtFace.visible = true
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
		var timer = get_tree().create_timer(randf_range(.2, .4))

		await timer.timeout

		if bIsAlive:
			lock_rotation = true
			var tween = get_tree().create_tween()
			tween.tween_property(self, "rotation_degrees", 0, .1)
			await tween.finished
			bCanMove = true
			modulate = Color.WHITE
			$Sprite2D/HurtFace.visible = false
		else:
			self_modulate = Color.BLACK

func SanitizeDirection(vector: Vector2) -> Vector2:
		if vector.x > 0:
			return Vector2.RIGHT  # Right
		else:
			return Vector2.LEFT  # Left
