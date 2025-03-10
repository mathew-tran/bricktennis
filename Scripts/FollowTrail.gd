extends Line2D

@export var ParentRef : Node2D
@export var bPlayerTrail = false

var Offset = Vector2.ZERO

@export var MaxTrailAmount = 30
func _ready():
	Offset = position

func _process(delta):
	if (bPlayerTrail and Finder.GetPlayer().bSwinging) or bPlayerTrail == false:
		var currentPosition = ParentRef.global_position + Offset
		add_point(currentPosition)
		print(currentPosition)
	
		if points.size() > MaxTrailAmount:
			remove_point(0)
	else:
		if points.size() > 0:
			remove_point(0)
	
