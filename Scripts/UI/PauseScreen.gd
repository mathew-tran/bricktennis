extends Control

var bCanUse = true
func _ready():

	EventManager.PlayerDeath.connect(OnPlayerDeath)
	EventManager.PlayerWon.connect(OnPlayerWon)


func OnPlayerWon():
	OnPlayerDeath()


func OnPlayerDeath():
	visible = false
	bCanUse = false

func _input(event):
	if bCanUse == false:
		return
	if event.is_action_pressed("pause"):
		visible = !visible


func _on_visibility_changed():
	if is_inside_tree():
		get_tree().paused = visible

		if visible:
			$VBoxContainer/Continue.grab_focus()


func _on_button_3_button_up():
	visible = false


func _on_restart_button_up():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_back_to_menu_button_up():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Title.tscn")
