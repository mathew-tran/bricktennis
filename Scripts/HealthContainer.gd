extends HBoxContainer

var Health = 0
func _ready():
	EventManager.PlayerHit.connect(OnPlayerHit)
	Health = get_child_count()


func OnPlayerHit():
	if Health - 1 <= get_child_count():
		get_child(Health - 1).modulate = Color(.01,.01,.01,1)
		Health -= 1
	EventManager.UpdatePlayerHealth.emit(Health)
