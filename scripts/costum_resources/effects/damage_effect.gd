class_name DamageEffect
extends Effect

@export var repeat_count_provider: NumericProvider
@export var repeat: int = 1
@export var damage_provider: NumericProvider
@export var damage_formula: NumericFormula
@export var no_modifiers: bool = false

func apply(source: Node, targets: Array[Node], card_context: Dictionary, previous_result: Variant = null) -> Variant:
	var value = damage_provider.get_value(previous_result, card_context)
	var card: Card = card_context.get("card")
	var modifiers :Array[Modifier] = []
	if card and card.has_enchantment():
		modifiers.append_array(card.enchantment.get_modifiers_by_type(Enums.NumericType.DAMAGE))
	var total_damage := 0
	var repeat_count = repeat
	if repeat_count_provider:
		repeat_count = repeat_count_provider.get_value(previous_result, card_context)
	for target: Creature in targets:
		for i in range(repeat_count):
			var damage = value
			if damage_formula:
				damage += damage_formula.calculate(target)
			total_damage += target.take_damage(DamageContext.new(source, target, damage, modifiers, no_modifiers))
			await target.get_tree().create_timer(0.1).timeout
	return total_damage
	
