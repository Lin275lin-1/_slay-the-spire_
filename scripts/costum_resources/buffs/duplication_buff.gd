# 记得改类名
class_name DuplicationBuff
extends Buff



	
func initialize() -> void:
	Events.card_played.connect(_on_card_played)
	agent.turn_ended.connect(_on_turn_ended)
		
func get_modifier() -> Array[Modifier]:
	return []

func _on_card_played(card: Card, card_context: Dictionary):
	# 防止无限循环
	if stacks > 0:
		await get_tree().create_timer(0.3).timeout
		remove_stack(1)
		card.play(card_context["player"], card_context["targets"], true)
		
func _on_turn_ended(_creature: Creature) -> void:
	remove_stack(stacks)
