extends Relic

func initialize_relic(owner: RelicUI) -> void:
	Events.player_hit.connect(func(): activate_relic(owner))
	
