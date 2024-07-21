extends Node

var Points = 0
var Multiplier = 1.0
var Combo = 0

var DefaultPointPosition = Vector2(1800,100)
@onready var PointTextClass = preload("res://Prefab/PointText.tscn")

var PointsToNextLife = 500

var CurrentPointsToLife = 0

var Levels = [0,1,2]
func _ready():
	EventManager.RewardPoints.connect(GivePoints)
	SpawnNextLevel()
	CurrentPointsToLife = PointsToNextLife


func SpawnNextLevel():
	if Levels.size() > 0:
		var instance = load("res://Levels/" + str(Levels[0]) + ".tscn").instantiate()
		add_child(instance)
		instance.global_position.x += 65
		Levels.pop_front()
		instance.LevelComplete.connect(OnLevelComplete)

func OnLevelComplete():
	EventManager.RewardPoints.emit(200)
	SpawnNextLevel()
	EventManager.NewRoundStart.emit()

func AddPointsToTotal(amount):
	Points += amount
	EventManager.PointUpdate.emit(Points)

	CurrentPointsToLife -= amount
	if CurrentPointsToLife <= 0:
		PointsToNextLife += 1000
		CurrentPointsToLife = PointsToNextLife
		EventManager.AddPlayerHealth.emit()

func GivePoints(amount, pointPosition):
	var newAmount = round(amount * Multiplier)
	Multiplier += .2
	Combo += 1
	AddPointsToTotal(newAmount)
	var instance = PointTextClass.instantiate()
	instance.global_position = pointPosition
	add_child(instance)
	instance.Setup("+" + str(newAmount))
	$MultiplierTimer.start()




func _on_multiplier_timer_timeout():
	Multiplier = 1.0
	if Combo > 0:
		var instance2 = PointTextClass.instantiate()
		instance2.global_position = DefaultPointPosition
		add_child(instance2)
		instance2.Setup(str(Combo) + "x COMBO!" )
		await instance2.Complete
		Combo = 0
		if Combo >= 10:
			GivePoints(1000, DefaultPointPosition)
		elif Combo >= 5:
			GivePoints(200, DefaultPointPosition)



