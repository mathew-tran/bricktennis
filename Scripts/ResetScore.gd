extends Label


func _ready():
	$ProgressBar.visible = false

func _process(delta):
	if Input.is_action_just_pressed("reset"):
		$Timer.start()
		$ProgressBar.visible = true
	if Input.is_action_just_released("reset"):
		$Timer.stop()
		$ProgressBar.visible = false

	$ProgressBar.max_value = $Timer.wait_time
	$ProgressBar.value = $Timer.wait_time - $Timer.time_left


func _on_timer_timeout():
	EventManager.ClearScore.emit()
	var timer = get_tree().create_timer(.3)
	await timer.timeout
	get_tree().reload_current_scene()
