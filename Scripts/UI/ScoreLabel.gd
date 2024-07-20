extends Label


func _ready():
	text = "0"
	EventManager.PointUpdate.connect(OnPointUpdate)


func OnPointUpdate(amount):
	text = str(amount)
