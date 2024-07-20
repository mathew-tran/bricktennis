extends Panel


var BlockAmount = 0
signal LevelComplete
func _ready():
	self_modulate.a = 0
	for child in get_children():
		child.Killed.connect(OnBlockKilled)

	BlockAmount = get_child_count()

func OnBlockKilled():
	BlockAmount -= 1
	if BlockAmount <= 0:
		LevelComplete.emit()
		queue_free()
