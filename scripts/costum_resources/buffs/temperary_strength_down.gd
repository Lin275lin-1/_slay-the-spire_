# 记得改类名
class_name TemperaryStrengthDown
extends Buff
	
func initialize() -> void:
	if agent and agent.has_signal("turn_ended"):
		agent.connect("turn_ended", _on_turn_ended)
		
func get_modifier() -> Array[Modifier]:
	return []

func get_description() -> String:
	return description.format({"stacks": stacks})

func _on_turn_ended(creature: Creature) -> void:
	creature.add_buff(ApplyBuffContext.new(creature, creature, stacks, "力量"))
	remove_stack(stacks)
