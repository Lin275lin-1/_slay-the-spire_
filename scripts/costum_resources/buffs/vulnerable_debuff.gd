class_name VulnerableDebuff
extends Buff

	
func initialize() -> void:
	if agent and agent.has_signal("before_take_damage"):
		agent.connect("before_take_damage", _on_before_take_damage)
	else:
		printerr("该对象没有before_take_damage信号")
		return
	if agent and agent.has_signal("turn_ended"):
		agent.connect("turn_ended", _on_turn_ended)

func get_modifier() -> Array[Modifier]:
	var modifier := Modifier.new(Enums.NumericType.DAMAGE, 0, 1.5, null)
	return [modifier]

func _on_before_take_damage(context: Context) -> void:
	context.modifiers.append(Modifier.new(Enums.NumericType.DAMAGE, 0, 1.5, null))

func _on_turn_ended(_creature: Node2D) -> void:
	remove_stack(1) 
