extends "res://objects/recipe.gd"

func _ready():
	ingredients = [
		"Tomato",
		"Meat",
		"Lettuce"
	]
	steps = [
		[ # x = 0
			{ # y = 0
				ingredients[0]: 1,
				ingredients[1]: 2,
				ingredients[2]: 4
			},
			{ # y = 1
				ingredients[0]: 3,
				ingredients[2]: 7
			},
			{ # y = 2
				ingredients[0]: 5,
				ingredients[1]: 7
			}
		],
		[ # x = 1
			{ # y = 0
				ingredients[1]: 3,
				ingredients[2]: 5
			},
			{ # y = 1
				ingredients[2]: 11
			},
			{ # y = 2
				ingredients[1]: 11
			},
			{ # y = 3
				ingredients[0]: 11
			}
		]
	]
