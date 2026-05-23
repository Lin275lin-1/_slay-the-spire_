extends Relic

func initialize_relic(owner: RelicUI) -> void:
	Events.card_played.connect(_on_card_played.bind(owner))
	
func _on_card_played(card: Card, _card_context: Dictionary, owner: RelicUI) -> void:
	if card.type == Card.Type.SKILL:
		if count < 9:
			count += 1
		else:
			activate_relic(owner)
			count = 0
		owner.update_count()
