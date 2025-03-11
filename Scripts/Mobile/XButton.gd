extends Button


func _on_button_down():
	Input.action_press("right_click", 1)


func _on_button_up():
	Input.action_release("right_click")
