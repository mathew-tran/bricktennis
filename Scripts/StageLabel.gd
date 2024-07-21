extends Label


func _ready():
	EventManager.StageUpdate.connect(OnStageUpdate)


func OnStageUpdate(level):
	text = "STAGE " + str(level)
