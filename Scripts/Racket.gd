extends RigidBody2D


func SetCollisionEnabled(bEnable):
	$CollisionShape2D.disabled = !bEnable
