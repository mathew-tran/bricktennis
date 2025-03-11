extends Control

func _enter_tree():
	visible = DisplayServer.is_touchscreen_available()
	
