class_name Enchantment
extends Resource

@export var id: String
@export var enchantment_name: String
@export_multiline var description: String
@export var icon: Texture2D
@export var stacks: int

func get_modifiers() -> Array[Modifier]:
	return []

func on_play(_player: Player, _targets: Array[Node]) -> void:
	pass

func get_description() -> String:
	return description

func get_modifiers_by_type(type_: Enums.NumericType) -> Array:
	var result := []
	for modifier: Modifier in get_modifiers():
		if modifier.type == type_:
			result.append(modifier)
	return result

func get_additional_card_description() -> String:
	return "";

func on_enchant_set(_card: Card) -> void:
	pass
