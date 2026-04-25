# 记得改类名
class_name FeelNoPainBuff
extends Buff



	
func initialize() -> void:
	if agent is Player:
		Events.card_exhausted.connect(_on_card_exhausted)
		
func get_modifier() -> Array[Modifier]:
	return []
	
func get_description() -> String:
	return description.format({"stacks": stacks})

func _on_card_exhausted(_card: Card) -> void:
	agent.gain_block(GainBlockContext.new(agent, agent, stacks, [], true))
