extends StaticBody2D

class_name Brick


var bIsDead = false
func _on_area_2d_body_entered(body):
	if body is Ball:
		if bIsDead:
			return
		bIsDead = true
		$CPUParticles2D.emitting = true
		EventManager.RewardPoints.emit(20, global_position)
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color(500,500,500,1), .4)
		await tween.finished

		queue_free()

