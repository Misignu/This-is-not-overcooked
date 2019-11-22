tool
extends "res://src/objects/recipe.gd"

func _ready():
	ingredients = [
		"Meat",
		"Lettuce"
	]
	# Fiz esse exemplo no _ready para ficar mais fácil de entender como o array ingredients funciona
	steps = [
		[ # x = 0
			{ # y = 0
				ingredients[0]: 1,
				ingredients[1]: 2
			},
			{ # y = 1
				ingredients[1]: 3
			},
			{ # y = 2
				ingredients[0]: 3
			}
		]
	]
