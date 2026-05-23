extends Relic

func initialize_relic(owner: RelicUI) -> void:
	Events.combat_won.connect(
		func(context: RewardContext):
			context.upgrade_skill = true
			owner.flash()
	)
