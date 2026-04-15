class_name DrawCardEffect
extends Effect

@export var draw_card_provider: NumericProvider

func apply(source: Node, _targets: Array[Node], card_context: Dictionary, previous_result: Variant = null) -> Variant:
	var value = draw_card_provider.get_value(previous_result, card_context)
	if source is Player:
		for i in range(value):
			await source.draw_card(DrawCardContext.new(source, source, 1))
			await source.get_tree().create_timer(0.2).timeout
	return null
