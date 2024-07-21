extends Control


func _ready():
	EventManager.PlayerWon.connect(OnPlayerWon)
	scale = Vector2(0,0)

func OnPlayerWon():

	visible = true

func _on_visibility_changed():
	if is_inside_tree():
		if is_visible_in_tree():
			Engine.time_scale = .8
			var tween = get_tree().create_tween()
			tween.tween_property(self, "scale", Vector2(1,1), .8)
			await tween.finished
			$VBoxContainer/Button.grab_focus()
			get_tree().paused = true
			Engine.time_scale = 1



func _on_button_button_up():
	get_tree().paused = false
	get_tree().reload_current_scene()



func _on_button_2_button_up():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Title.tscn")
