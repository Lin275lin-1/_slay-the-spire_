extends Relic

func initialize_relic(owner: RelicUI) -> void:
	Events.combat_won.connect(
		func(context: RewardContext):
			context.extra_gold.append(15)
			owner.flash()
	)
