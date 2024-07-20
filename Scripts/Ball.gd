extends RigidBody2D

var MaxSpeed = 2000
# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	if linear_velocity.length() > MaxSpeed:
		linear_velocity = linear_velocity.normalized() * MaxSpeed

