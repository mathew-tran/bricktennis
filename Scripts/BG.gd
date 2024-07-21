extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	EventManager.BGColorChange.connect(OnBGColorChange)

func OnBGColorChange(newColor):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", newColor, 1.5)
