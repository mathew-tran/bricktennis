extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Button2.grab_focus()

	var timer = get_tree().create_timer(randf_range(5, 10.0))
	await timer.timeout
	$AnimationPlayer.play("animate")

func _on_button_2_button_up():
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func _on_exit_button_button_up():
	get_tree().quit()



func _on_credits_credits_exited():
	$VBoxContainer/Button2.grab_focus()


func _on_credits_button_up():
	$Credits.visible = true


func _on_animation_player_animation_finished(anim_name):
	var timer = get_tree().create_timer(randf_range(5, 10.0))
	await timer.timeout
	$AnimationPlayer.play("animate")
