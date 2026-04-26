# 记得改类名
class_name DuplicationBuff
extends Buff



	
func initialize() -> void:
	Events.before_card_played.connect(_before_card_played)
		
func get_modifier() -> Array[Modifier]:
	return []

func _before_card_played(card: Card, card_context: Dictionary):
	# 防止无限循环
	if stacks > 0:
		await get_tree().create_timer(0.3).timeout
		remove_stack(1)
		card.play(card_context["player"], card_context["targets"], true)
		
	
