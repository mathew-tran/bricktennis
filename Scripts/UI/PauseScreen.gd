extends Control

var bCanUse = true
func _ready():

	EventManager.PlayerDeath.connect(OnPlayerDeath)


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
