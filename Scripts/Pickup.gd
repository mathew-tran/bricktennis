extends RigidBody2D

var bHasPickedUp = false



func _on_area_2d_body_entered(body):
	if bHasPickedUp:
		return
	if body is Player:
		bHasPickedUp = true
		freeze = true
		set_collision_layer_value(1, 0)
		var tween = get_tree().create_tween()
		$AudioStreamPlayer2D.play()
		EventManager.AddPlayerHealth.emit()
		EventManager.RewardPoints.emit(200, Finder.GetPlayer().global_position)
		tween.tween_property(self, "scale", Vector2.ZERO, .3)
		await tween.finished
		queue_free()
