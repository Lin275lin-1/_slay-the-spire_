extends Relic

func initialize_relic(owner: RelicUI) -> void:
	Events.card_played.connect(_on_card_played.bind(owner))
	
func _on_card_played(_card: Card, card_context: Dictionary, owner: RelicUI) -> void:
	var energy_cost :int = card_context.get("energy_cost", 0)
	if energy_cost >= 2:
		activate_relic(owner)
