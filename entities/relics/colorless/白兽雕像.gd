extends Relic

func initialize_relic(_owner: RelicUI) -> void:
	Events.combat_won.connect(
		func(context: RewardContext) -> void:
			context.extra_potion_count += 1
	)
