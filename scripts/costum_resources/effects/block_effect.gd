class_name BlockEffect
extends Effect

@export var block_provider: NumericProvider
@export var block_formula: NumericFormula
@export var no_modifiers: bool = false

func apply(source: Node, targets: Array[Node], card_context: Dictionary, previous_result: Variant = null) -> Variant:
	var value = block_provider.get_value(previous_result, card_context)
	var card: Card = card_context.get("card")
	
	var modifiers :Array[Modifier] = []
	if card and card.has_enchantment():
		modifiers.append_array(card.enchantment.get_modifiers_by_type(Enums.NumericType.BLOCK))
	for target: Creature in targets:
		var block = value
		if block_formula:
			block += block_formula.calculate(target)
		target.gain_block(GainBlockContext.new(source, target, block, modifiers, no_modifiers))
	return null
	
