# 记得改类名
class_name BufferBuff
extends Buff

	
func initialize() -> void:
	if agent and agent.has_signal("before_take_damage"):
		agent.connect("before_take_damage", _on_before_take_damage)
		
func get_modifier() -> Array[Modifier]:
	var modifier := Modifier.new(Enums.NumericType.DAMAGE, 0, 0.0, null)
	return [modifier]

func _on_before_take_damage(context: Context) -> void:
	context.modifiers.append(Modifier.new(Enums.NumericType.DAMAGE, 0, 0.0, null))
	remove_stack(1)
