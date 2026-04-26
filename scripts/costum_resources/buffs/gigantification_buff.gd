# 记得改类名
class_name GigantificationBuff
extends Buff

func initialize() -> void:
	if agent is Player:
		agent.before_attack.connect(_on_before_attack)	
		Events.card_played.connect(_on_card_played)
		
func get_description() -> String:
	return description
		
func get_modifier() -> Array[Modifier]:
	var modifier := Modifier.new(Enums.NumericType.DAMAGE, 0, 3.0, null)
	return [modifier]
	
func _on_before_attack(context: Context) -> void:
	context.modifiers.append(Modifier.new(Enums.NumericType.DAMAGE, 0, 3.0, null))

func _on_card_played(card: Card, _card_context: Dictionary) -> void:
	if card.type == Card.Type.ATTACK:
		remove_stack(stacks)
