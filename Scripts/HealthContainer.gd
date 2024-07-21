extends HBoxContainer

var Health = 0
var MaxHealth = 0
func _ready():
	EventManager.PlayerHit.connect(OnPlayerHit)
	EventManager.AddPlayerHealth.connect(OnAddPlayerHealth)
	Health = get_child_count()
	MaxHealth = get_child_count()
	UpdateHealth()


func OnAddPlayerHealth():
	modulate = Color.GREEN
	var timer = get_tree().create_timer(.3)
	$"..".play()

	Health += 1
	if Health >= MaxHealth:
		Health = MaxHealth
		EventManager.RewardPoints.emit(100)

	UpdateHealth()

	await timer.timeout
	EventManager.UpdatePlayerHealth.emit(Health)
	modulate = Color.WHITE

func OnPlayerHit():
	modulate = Color.RED
	var timer = get_tree().create_timer(.3)


	Health -= 1
	if Health <= 0:
		Health = 0
	UpdateHealth()
	EventManager.UpdatePlayerHealth.emit(Health)
	await timer.timeout
	modulate = Color.WHITE

func UpdateHealth():
	for x in range(1, get_child_count() +1):
		if Health >= x:
			get_child(x-1).modulate = Color.WHITE
		else:
			get_child(x-1).modulate = Color(.01,.01,.01,1)

	var tween = get_tree().create_tween()
	scale = Vector2(1,1)
	tween.tween_property(self, "scale", Vector2(.5,.5), .2)
