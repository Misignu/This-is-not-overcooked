extends "res://src/objects/areas/pick_places/delivery_point.gd"
"""
Treadmill é um DeliveryPoint que recebe pratos com receitas prontas e retorna um prato sujo atravez do sinal recipe_delivered.
"""
signal recipe_delived

func _on_Tween_tween_completed(object, key: String) -> void:
	
	if "Plate" in object.name and key == ":modulate":
		
		_buffer_delivery(.remove_object())
		object.is_clean = false

# @override
func insert_object(object: PickableObject) -> bool:
	var was_inserted: bool
	
	if "Plate" in object.name:
		
		if object.get_recipe() != null and object.is_clean:
			was_inserted = .insert_object(object)
	
	if was_inserted:
		_delivery_animation(object)
	
	return was_inserted

func remove_object():
	return null

# @main
func _delivery_animation(plate: PickableObject) -> void:
	
	$Tween.interpolate_property(plate, "modulate", plate.modulate, Color.transparent, 2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT) # WATCH -> Verificar a possibilidade de interpolar apenas a propriedade alpha de modulate
	$Tween.start()
	$DeliverSineSFX.play()
	emit_signal("recipe_delived", plate.current_recipe)
