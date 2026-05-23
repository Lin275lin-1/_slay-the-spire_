class_name DrawCardEffect
extends Effect

#@export var draw_card_provider: NumericProvider

func apply(source: Node, _targets: Array[Node], _card_context: Dictionary, _previous_result: Variant = null) -> Variant:
	#var value = draw_card_provider.get_value(previous_result, card_context)
	if animation_name and source is Player:
		source.animate_player(animation_name)
	var drawn: Variant = null
	if source is Player:
		#for i in range(value):
		drawn = await source.draw_card(DrawCardContext.new(source, source, 1))
		# 只有成功抽牌才会等待
		if drawn != null:
			await source.get_tree().create_timer(0.2).timeout
	return drawn
