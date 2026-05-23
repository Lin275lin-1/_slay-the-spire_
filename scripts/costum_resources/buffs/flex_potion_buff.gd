# 记得改类名
class_name FlexPotionBuff
extends Buff

	
func initialize() -> void:
	if agent and agent.has_signal("turn_ended"):
		agent.connect("turn_ended", _on_turn_ended)

func get_description() -> String:
	return description.format({"stacks": stacks})

func get_modifier() -> Array[Modifier]:
	return []

func _on_turn_ended(creature: Node2D) -> void:
	creature = creature as Creature
	creature.add_buff(ApplyBuffContext.new(creature, creature, -stacks, "力量"))
	remove_stack(stacks)
