extends Node2D

func _ready():
	
	var player: Game.Player
	var character: KinematicBody2D
	
	for i in range(4):
		
		player = Game.players[i]
		character = $Players.get_child(i)
		
		if  player.is_device_atached():
			
			character.get_node("Sprite").texture = Game.players[i].character
			character.set_controller_index(player.device)
			
		else:
			character.shift_visibility(false)
