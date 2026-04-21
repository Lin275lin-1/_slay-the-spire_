class_name HealEffect
extends Effect

@export var repeat_count_provider: NumericProvider
@export var repeat: int = 1
@export var heal_provider: NumericProvider

func apply(source: Node, targets: Array[Node], card_context: Dictionary, previous_result: Variant = null) -> Variant:
	var value = heal_provider.get_value(previous_result, card_context)
	var total_heal := 0
	var repeat_count = repeat
	if repeat_count_provider:
		repeat_count = repeat_count_provider.get_value(previous_result, card_context)
	for target: Creature in targets:
		for i in range(repeat_count):
			var heal_amount = value
			total_heal += source.heal(HealContext.new(source, target, heal_amount))
			if animation_name and source is Player:
				source.animate_player(animation_name)
				await source.get_tree().create_timer(animation_delay).timeout
			else:
				await source.get_tree().create_timer(0.1).timeout
	return total_heal
	
