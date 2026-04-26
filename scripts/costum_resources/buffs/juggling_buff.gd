# 记得改类名
class_name JugglingBuff
extends Buff


var attack_count := 0
var used = false
	
func initialize() -> void:
	if agent is Player:
		Events.card_played.connect(_on_card_played)
		agent.turn_ended.connect(_on_turn_ended)
		
func get_modifier() -> Array[Modifier]:
	return []

func get_description() -> String:
	return description

func _on_turn_ended(_creature: Creature) -> void:
	attack_count = 0
	stacks = attack_count + 1
	used = false

func _on_card_played(card: Card, _card_context: Dictionary) -> void:
	if not used and card.type == Card.Type.ATTACK:
		attack_count += 1
		if attack_count == 3:
			(agent as Player).put_card_in_hand(card.duplicate())
			attack_count = 0
			used = true
		stacks = attack_count + 1
