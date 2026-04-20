class_name ConditionalEffect
extends Effect

@export var condition: Condition
@export var if_effects: Array[Effect]
@export var else_effects: Array[Effect]

# 这些effect没有入栈，当作特性算了
func apply(source: Node, targets: Array[Node], card_context: Dictionary, previous_result: Variant = null) -> Variant:
	if condition.is_met(source, targets[0], card_context):
		var last = previous_result
		for effect: Effect in if_effects:
			last = await effect.execute(source, card_context, last)
		return last
	else:
		var last = previous_result
		for effect: Effect in else_effects:
			last = await effect.execute(source, card_context, last)
		return last

#var target = context.get("primary_target")
	#if condition.is_met(source, target, context):
		#var last = previous_result
		#for effect in effects:
			#last = effect.execute(source, context, last)
		#return last
	#else:
		#var last = previous_result
		#for effect in else_effects:
			#last = effect.execute(source, context, last)
		#return last
