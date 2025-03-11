extends Button


func _on_button_down():
	Input.action_press("move_left", 1)


func _on_button_up():
	Input.action_release("move_left")


func _on_pressed():
	if button_pressed:
		Input.action_press("move_left", 1)
	else:
		Input.action_release("move_left")
