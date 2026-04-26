# 记得改类名
class_name BlockNextTurnBuff
extends Buff


func initialize() -> void:
	if agent and agent.has_signal("after_turn_started"):
		agent.connect("after_turn_started", _on_after_turn_started)
		
func get_modifier() -> Array[Modifier]:
	return []

func get_description() -> String:
	return description.format({"stacks": stacks})

func _on_after_turn_started(creature: Creature) -> void:
	creature.gain_block(GainBlockContext.new(creature, creature, stacks, [], true))
	remove_stack(stacks)
