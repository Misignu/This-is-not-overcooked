extends Sprite

export var price: int = 100 setget, get_price
const INGREDIENTS := [ # WATCH -> Implementar no hamburger. Ou implementar aqui
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

func add_ingredient(ingredient: Ingredient) -> bool:
	var current_frame = frame
	
	for ingredient_name in INGREDIENTS[frame_coords.x][frame_coords.y]:
		
		if ingredient_name in ingredient.name:
			frame = INGREDIENTS[frame_coords.x][frame_coords.y]
			break
	
	return current_frame != frame

func get_price() -> int:
	
	return price
