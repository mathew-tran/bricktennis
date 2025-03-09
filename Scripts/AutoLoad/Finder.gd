extends Node

func GetBall() -> Ball:
	var result = get_tree().get_nodes_in_group("Ball")
	if result:
		return result[0]
	return null

func GetPlayer() -> Player:
	var result = get_tree().get_nodes_in_group("Player")
	if result:
		return result[0]
	return null
	
