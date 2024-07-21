extends Panel


signal CreditsExited

func _on_visibility_changed():
	if is_inside_tree():
		$Credits/Continue.grab_focus()


func _on_continue_button_up():
	visible = false
	CreditsExited.emit()
