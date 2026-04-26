# 记得改类名
class_name FragileDebuff
extends Buff

	
func initialize() -> void:
	if agent and agent.has_signal("before_gain_block"):
		agent.connect("before_gain_block", _on_before_gain_block)
	else:
		printerr("该对象没有before_gain_block信号")
		return
	if agent and agent.has_signal("turn_ended"):
		agent.connect("turn_ended", _on_turn_ended)

func get_modifier() -> Array[Modifier]:
	var modifier := Modifier.new(Enums.NumericType.BLOCK, 0, 0.75, null)
	return [modifier]

func _on_before_gain_block(context: Context) -> void:
	context.modifiers.append(Modifier.new(Enums.NumericType.BLOCK, 0, 0.75, null))

func _on_turn_ended(_creature: Node2D) -> void:
	remove_stack(1) 
