extends Relic

func initialize_relic(owner: RelicUI) -> void:
	Events.combat_won.connect(
		func(_context: RewardContext):
			count = 0
			owner.update_count()
	)
	
func activate_relic(owner: RelicUI) -> void:
	if count < 2:
		count += 1
	else:
		super.activate_relic(owner)
		count = 0
	owner.update_count()
