class_name VigorBuff
extends Buff

func initialize() -> void:
	if agent is Player:
		Events.card_played.connect(_on_card_played)
		agent.before_attack.connect(_on_before_attack)
		
func get_modifier() -> Array[Modifier]:
	var modifier := Modifier.new(Enums.NumericType.DAMAGE, stacks, 1.0, null)
	return [modifier]

func get_description() -> String:
	return description.format({"stacks": stacks})

func _on_before_attack(context: Context) -> void:
	context.modifiers.append(Modifier.new(Enums.NumericType.DAMAGE, stacks, 1.0, null))

func _on_card_played(card: Card, _card_context: Dictionary) -> void:
	if _has_attack_effect(card.effects):
		remove_stack(stacks)

func _has_attack_effect(effects: Array[Effect]) -> bool:
	for effect in effects:
		if effect is AttackEffect:
			return true
		if effect is ConditionalEffect:
			if _has_attack_effect(effect.if_effects):
				return true
		if effect is IterationEffect:
			if _has_attack_effect(effect.effects):
				return true
	return false
