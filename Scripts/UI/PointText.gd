extends Node2D

signal Complete
func Setup(newText):
	$Label.text = str(newText)
	var tween = get_tree().create_tween()
	tween.tween_property($Label, "global_position", global_position - Vector2(0, 120), .5)
	await tween.finished
	Complete.emit()
	queue_free()
