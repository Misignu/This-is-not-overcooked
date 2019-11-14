tool
extends "res://objects/recipe.gd"

func _ready():
	# Fiz esse exemplo no _ready para ficar mais fácil de entender como o array ingredients funciona
	ingredients = [
		[ # x = 0
			{ # y = 0
				"Meat": 1,
				"Lettuce": 2
			},
			{ # y = 1
				"Lettuce": 3
			},
			{ # y = 2
				"Meat": 3
			}
		]
	]
