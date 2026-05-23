# 记得改类名
class_name NoDrawDebuff
extends Buff

	
func initialize() -> void:
	if agent and agent.has_signal("before_draw_card"):
		agent.connect("before_draw_card", _on_before_draw_cards)
	else:
		printerr("该对象没有before_draw_card信号")
		return
	if agent and agent.has_signal("turn_ended"):
		agent.connect("turn_ended", _on_turn_ended)

func _on_before_draw_cards(context: Context) -> void:
	context.amount = 0

func _on_turn_ended(_creature: Node2D) -> void:
	remove_stack(1) 
