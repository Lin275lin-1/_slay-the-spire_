class_name CrueltyBuff
extends Buff

func initialize() -> void:
	if agent and agent.has_signal("before_attack"):
		agent.connect("before_attack", _on_before_attack)

func get_modifier() -> Array[Modifier]:
	var modifier := Modifier.new(Enums.NumericType.DAMAGE, 0, 1.0 + 0.01 * stacks, null)
	return [modifier]

func _on_before_attack(context: Context) -> void:
	context.modifiers.append(Modifier.new(Enums.NumericType.DAMAGE, 0, 1.0 + 0.01 * stacks, null))

func get_description() -> String:
	return "造成的攻击伤害提高{stacks}%".format({"stacks": stacks})
