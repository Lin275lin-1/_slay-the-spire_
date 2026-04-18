class_name LossHealthEffect
extends Effect

@export var lose_health_provider: NumericProvider

func apply(source: Node, targets: Array[Node], card_context: Dictionary, previous_result: Variant = null) -> Variant:
	var value := lose_health_provider.get_value(previous_result, card_context)
	var card: Card = card_context.get("card")
	var modifiers :Array[Modifier] = []
	if card and card.has_enchantment():
		modifiers.append_array(card.enchantment.get_modifiers_by_type(Enums.NumericType.LOSE_HEALTH))
	var total_damage := 0
	for target: Creature in targets:
		total_damage += target.lose_health(LoseHealthContext.new(source, target, value, modifiers))
	return total_damage
