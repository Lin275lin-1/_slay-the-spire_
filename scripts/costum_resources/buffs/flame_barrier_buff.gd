# 记得改类名
class_name FlameBarrierBuff
extends Buff


func initialize() -> void:
	if agent and agent.has_signal("after_take_damage"):
		agent.connect("after_take_damage", _on_after_take_damage)
	if agent and agent.has_signal("turn_ended"):
		agent.connect("turn_ended", _on_turn_ended)

func get_modifier() -> Array[Modifier]:
	return []

func _on_after_take_damage(context: Context) -> void:
	# 不会触发 before_take_damage
	if context.source is Creature:
		context.source.take_damage_without_signals(stacks)

func _on_turn_ended(_creature: Creature) -> void:
	remove_stack(stacks)

func get_description() -> String:
	return description.format({"stacks": stacks})
	
