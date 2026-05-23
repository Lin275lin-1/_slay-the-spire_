class_name IterationEffect
extends Effect

@export var count_provider: NumericProvider
@export var effects: Array[Effect]

func execute(source: Node, card_context: Dictionary = {}, previous_result: Variant = null) -> Variant:
	var count = count_provider.get_value(previous_result, card_context)
	var last_result = previous_result
	for i in range(count):
		for effect in effects:
			if _is_targets_valid(card_context.get("targets", [null])):
				last_result = await effect.execute(source, card_context)
	return last_result

func _is_targets_valid(targets: Array) -> bool:
	for target in targets:
		if not is_instance_valid(target):
			return false
	return true
