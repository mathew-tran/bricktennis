extends Control

var DefaultAmount = 600

var Amount = 600

var SavePath = "user://score.save"
func _ready():
	EventManager.PublishHighScore.connect(OnPublishHighScore)
	EventManager.ClearScore.connect(OnClearScore)
	$Label3.visible = false
	LoadScore()

func OnClearScore():
	modulate = Color.RED
	ClearScore()

func OnPublishHighScore(newScore):
	if newScore > Amount:
		Amount = newScore
		$Label3.visible = true
		SaveScore()
		LoadScore()


func SaveScore():
	var file = FileAccess.open(SavePath, FileAccess.WRITE)
	file.store_var(Amount)
	file.close()

func LoadScore():
	if FileAccess.file_exists(SavePath):
		var file = FileAccess.open(SavePath, FileAccess.READ)
		Amount = file.get_var()
		file.close()
	$VBoxContainer/Label2.text = str(Amount)

func ClearScore():
	var file = FileAccess.open(SavePath, FileAccess.WRITE)
	file.store_var(DefaultAmount)
	file.close()
	LoadScore()
