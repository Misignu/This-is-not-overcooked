extends "res://objects/recipe.gd"

func _ready():
	ingredients = [
		[ # x = 0
			{ # y = 0
				"Tomato": 1,
				"Meat": 2,
				"Lettuce": 4
			},
			{ # y = 1
				"Tomato": 3,
				"Lettuce": 7
			},
			{ # y = 2
				"Tomato": 5,
				"Meat": 7
			}
		],
		[ # x = 1
			{ # y = 0
				"Meat": 3,
				"Lettuce": 5
			},
			{ # y = 1
				"Lettuce": 11
			},
			{ # y = 2
				"Meat": 11
			},
			{ # y = 3
				"Tomato": 11
			}
		]
	]
