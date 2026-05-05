extends Relic

func initialize_relic(owner: RelicUI) -> void:
	count = 2
	owner.update_count()
	Events.combat_won.connect(
		func(context: RewardContext):
			if count > 0:
				context.upgrade_all = true
				count -= 1
				owner.update_count()
	)
