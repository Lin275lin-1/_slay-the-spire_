extends Relic

func initialize_relic(owner: RelicUI) -> void:
	Events.card_exhausted.connect(
		func(_card: Card): 
			activate_relic(owner)
	)
