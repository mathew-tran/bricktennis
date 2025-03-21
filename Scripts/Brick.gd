extends StaticBody2D

class_name Brick


var bIsDead = false

signal Killed

@export var PointsGained = 20
@export var ShineDuration : float = 1.0
@export var ShineIntensity : float = 1.0

@onready var HighlightMaterial = preload("res://Shader/Brick.tres")

@export var ChanceToDropPickup = 5

func _enter_tree():
	$Sprite2D.scale = Vector2.ZERO
var time_passed : float = 0.0

func _ready():
	time_passed = randf_range(0.0, 80.0)
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2(1,1), .2)




func _process(delta: float) -> void:
	time_passed += delta
	if HighlightMaterial:
		$Sprite2D.material.set_shader_parameter("shine_duration", ShineDuration)
		$Sprite2D.material.set_shader_parameter("shine_intensity", ShineIntensity)
		$Sprite2D.material.set_shader_parameter("time", time_passed)


func _on_area_2d_body_entered(body):
	if body is Ball:
		if bIsDead:
			return
			
		var result = randi() % 100
		if result <= ChanceToDropPickup:
			var instance = load("res://Prefab/Pickup.tscn").instantiate()
			instance.global_position = global_position
			Finder.GetItems().add_child(instance)
		Finder.GetGame().ApplySlow()
		body.Hit()
		body.ShowRacketHitEffect()
		bIsDead = true
		$AudioStreamPlayer2D.play()
		$CPUParticles2D.emitting = true
		EventManager.RewardPoints.emit(PointsGained, global_position)
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color(500,500,500,1), .15)
		await tween.finished
		Killed.emit()

		queue_free()
