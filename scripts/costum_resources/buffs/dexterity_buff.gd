# 记得改类名
class_name DexterityBuff
extends Buff

func initialize() -> void:
	if agent and agent.has_signal("before_gain_block"):
		agent.connect("before_gain_block", _on_before_gain_block)
	else:
		printerr("该对象没有before_gain_block信号")
	
func get_description() -> String:
	if stacks > 0:
		return "从卡牌获得的格挡提高{stacks}点".format({"stacks": stacks})
	else:
		return "从卡牌获得的格挡降低{stacks}点".format({"stacks": -stacks})
		
func get_modifier() -> Array[Modifier]:
	var modifier := Modifier.new(Enums.NumericType.BLOCK, stacks, 1.0, null)
	return [modifier]
	
func _on_before_gain_block(context: Context) -> void:
	context.modifiers.append(Modifier.new(Enums.NumericType.BLOCK, stacks, 1.0, null))
