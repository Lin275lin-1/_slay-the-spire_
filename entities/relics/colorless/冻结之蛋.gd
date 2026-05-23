extends Relic

func initialize_relic(owner: RelicUI) -> void:
	Events.combat_won.connect(
		func(context: RewardContext):
			context.upgrade_power = true
			owner.flash()
	)
