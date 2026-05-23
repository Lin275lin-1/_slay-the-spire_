class_name CrimsonMantleBuff
extends Buff

func initialize() -> void:
	if agent is Player:
		agent.after_turn_started.connect(_on_after_turn_started)
		
func get_modifier() -> Array[Modifier]:
	return []
	
func get_description() -> String:
	return description.format({"stacks": stacks})

func _on_after_turn_started(_creature: Creature) -> void:
	agent.lose_health(LoseHealthContext.new(agent, agent, 1, [], true))
	agent.gain_block(GainBlockContext.new(agent, agent, stacks, [], true))
