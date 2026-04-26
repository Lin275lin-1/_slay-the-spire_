# 记得改类名
class_name GigantificationBuff
extends Buff

func initialize() -> void:
	if agent and agent.has_signal("before_attack"):
		agent.connect("before_attack", _on_before_attack)
		
func get_modifier() -> Array[Modifier]:
	var modifier := Modifier.new(Enums.NumericType.DAMAGE, 0, 3.0, null)
	return [modifier]

func _on_before_attack(context: Context) -> void:
	context.modifiers.append(Modifier.new(Enums.NumericType.DAMAGE, 0, 3.0, null))
	remove_stack(1)
