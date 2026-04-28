extends Relic

var available := false

func initialize_relic(owner: RelicUI) -> void:
	Events.combat_room_entered.connect(
		func(room: Room, _run_stats: RunStats, _char_stats: CharacterStats):
			if room.enemy_encounter.type == EnemyEncounter.Type.STRONG or room.enemy_encounter.type == EnemyEncounter.Type.WEAK:
				available = true
			else:
				available = false
	)
	Events.combat_won.connect(
		func(context: RewardContext):
			if available:
				context.extra_card_count += 1
				owner.flash()
				available = false
	)
