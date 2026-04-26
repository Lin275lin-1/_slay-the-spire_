# 记得改类名
class_name RageBuff
extends Buff



	
func initialize() -> void:
	if agent and agent.has_signal("turn_ended"):
		agent.connect("turn_ended", _on_turn_ended)
	if agent is Player:
		Events.card_played.connect(_on_card_played)
		
		
func get_modifier() -> Array[Modifier]:
	return []

func get_description() -> String:
	return description.format({"stacks": stacks})

func _on_card_played(card: Card, _card_context: Dictionary) -> void:
	if card.type == Card.Type.ATTACK:
		agent.gain_block(GainBlockContext.new(agent, agent, stacks, [], true))

func _on_turn_ended(_source: Creature) -> void:
	remove_stack(stacks)
