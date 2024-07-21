extends StaticBody2D

class_name Brick


var bIsDead = false

signal Killed

@export var PointsGained = 20

func _enter_tree():
	$Sprite2D.scale = Vector2.ZERO

func _ready():

	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2(1,1), .3)

func _on_area_2d_body_entered(body):
	if body is Ball:
		if bIsDead:
			return
		bIsDead = true
		$AudioStreamPlayer2D.play()
		$CPUParticles2D.emitting = true
		EventManager.RewardPoints.emit(PointsGained, global_position)
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color(500,500,500,1), .4)
		await tween.finished
		Killed.emit()

		queue_free()

