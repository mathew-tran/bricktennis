extends Panel


var BlockAmount = 0
signal LevelComplete
@export var ColorToTweenTo : Color
func _ready():
	self_modulate.a = 0
	for child in get_children():
		child.Killed.connect(OnBlockKilled)

	BlockAmount = get_child_count()
	EventManager.BGColorChange.emit(ColorToTweenTo)


func OnBlockKilled():
	BlockAmount -= 1
	if BlockAmount <= 0:
		LevelComplete.emit()
		queue_free()
