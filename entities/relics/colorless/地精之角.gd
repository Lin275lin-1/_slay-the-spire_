extends Relic

func initialize_relic(owner: RelicUI) -> void:
	Events.enemy_died.connect(func(): activate_relic(owner))
	
