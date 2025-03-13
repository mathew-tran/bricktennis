extends RigidBody2D

var bHasPickedUp = false

enum PICKUP_TYPE {
	LIFE,
	POINTS,
	MULT
}

var PickupType : PICKUP_TYPE
func _enter_tree():
	var result = randi() %  PICKUP_TYPE.size()
	PickupType = result
	
	match PickupType:
		PICKUP_TYPE.LIFE:
			$Sprite2D.texture = load("res://Art/GearPickup.svg")
		PICKUP_TYPE.POINTS:
			$Sprite2D.texture = load("res://Art/PlayerLives.svg")
		
		
func _ready():
	$AnimationPlayer.play("anim")
	
func _on_area_2d_body_entered(body):
	if bHasPickedUp:
		return
	if body is Player:
		bHasPickedUp = true
		freeze = true
		set_collision_layer_value(1, 0)
		var tween = get_tree().create_tween()
		$AudioStreamPlayer2D.play()
		
		match PickupType:
			PICKUP_TYPE.LIFE:
				EventManager.AddPlayerHealth.emit()
				EventManager.RewardPoints.emit(200, Finder.GetPlayer().global_position)
			PICKUP_TYPE.POINTS:
				EventManager.RewardPoints.emit(600, Finder.GetPlayer().global_position)
				
		tween.tween_property(self, "scale", Vector2.ZERO, .3)
		await tween.finished
		queue_free()
