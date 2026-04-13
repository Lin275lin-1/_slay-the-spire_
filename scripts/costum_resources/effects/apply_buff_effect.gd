class_name ApplyBuffEffect
extends Effect

# 没有必要在资源中直接导出buff节点
@export var buff_name: String
@export var buff_stack_provider: NumericProvider

func apply(source: Node, targets: Array[Node], card_context: Dictionary, previous_result: Variant = null) -> Variant:
	var value = buff_stack_provider.get_value(previous_result, card_context)
	source = source as Creature
	var total = 0
	for target: Creature in targets:
		if target:
			total += source.apply_buff(ApplyBuffContext.new(source, target, value, BuffLibrary.buff_scene[buff_name].new()))
	return total
	
