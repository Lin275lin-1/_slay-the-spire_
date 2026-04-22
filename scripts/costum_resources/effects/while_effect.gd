class_name WhileEffect
extends Effect

@export var condition: Condition
@export var effects: Array[Effect]
@export var max_iterations: int = 20


	
func apply(source: Node, targets: Array[Node], card_context: Dictionary, previous_result: Variant = null) -> Variant:
	var iterations := 0
	var last_result = previous_result
	var primary_target = targets[0] if len(targets) > 0 else null
	while condition.is_met(source, primary_target, card_context, last_result):
		if iterations > max_iterations:
			break
		for effect: Effect in effects:
			last_result = await effect.execute(source, card_context, last_result)
		iterations += 1
	return last_result
