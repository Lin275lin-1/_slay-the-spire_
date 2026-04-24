# 记得改类名
class_name StrengthBuff
extends Buff

func initialize() -> void:
	if agent and agent.has_signal("before_attack"):
		agent.connect("before_attack", _on_before_attack)
	else:
		printerr("该对象没有before_attack信号")
		return
		
func get_modifier() -> Array[Modifier]:
	var modifier := Modifier.new(Enums.NumericType.DAMAGE, stacks, 1.0, null)
	return [modifier]

func get_description() -> String:
	if stacks > 0:
		return "造成的攻击伤害提高{stacks}点".format({"stacks": stacks})
	else:
		return "造成的攻击伤害降低{stacks}点".format({"stacks": -stacks})

func _on_before_attack(context: Context) -> void:
	context.modifiers.append(Modifier.new(Enums.NumericType.DAMAGE, stacks, 1.0, null))
