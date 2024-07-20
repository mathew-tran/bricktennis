extends Node

var Points = 0
var Multiplier = 1.0
var Combo = 0

var DefaultPointPosition = Vector2(1800,100)
@onready var PointTextClass = preload("res://Prefab/PointText.tscn")
func _ready():
	EventManager.RewardPoints.connect(GivePoints)

func AddPointsToTotal(amount):
	Points += amount
	EventManager.PointUpdate.emit(Points)

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



