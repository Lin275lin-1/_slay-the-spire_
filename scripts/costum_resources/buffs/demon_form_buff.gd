# 记得改类名
class_name DemonFormBuff
extends Buff

	
func initialize() -> void:
	if agent and agent.has_signal("before_turn_started"):
		agent.connect("before_turn_started", _on_before_turn_started)

func get_description() -> String:
	return description.format({"stacks": stacks})

func _on_before_turn_started(creature: Node2D) -> void:
	(creature as Creature).apply_buff(ApplyBuffContext.new(creature, creature, stacks, "力量"))
