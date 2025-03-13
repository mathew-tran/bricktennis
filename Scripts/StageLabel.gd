extends Label


func _ready():
	EventManager.StageUpdate.connect(OnStageUpdate)
	OnStageUpdate(1)


func OnStageUpdate(level):
	text = "STAGE " + str(level)
