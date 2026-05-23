class_name ApplyBuffEffect
extends Effect

# 没有必要在资源中直接导出buff节点
@export var buff_name: String
@export var buff_stack_provider: NumericProvider

@export var buff_stack_formula: NumericFormula

func apply(source: Node, targets: Array[Node], card_context: Dictionary, previous_result: Variant = null) -> Variant:
	var value = buff_stack_provider.get_value(previous_result, card_context)
	source = source as Creature
	var total = 0
	for target: Creature in targets:
		if target:
			var buff_stack = value
			if buff_stack_formula:
				buff_stack += buff_stack_formula.calculate(target)
			total += source.apply_buff(ApplyBuffContext.new(source, target, buff_stack, buff_name))
	if animation_name and source is Player:
		source.animate_player(animation_name)
		await source.get_tree().create_timer(animation_delay).timeout
	else:
		await source.get_tree().create_timer(0.1).timeout
	return total
	
