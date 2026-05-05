extends Relic

var available := false

func initialize_relic(_owner: RelicUI) -> void:
	Events.combat_room_entered.connect(
		func(room: Room, _run_stats: RunStats, _char_stats: CharacterStats):
			if room.enemy_encounter.type == EnemyEncounter.Type.BOSS:
				available = true
			else:
				available = false
	)
	Events.combat_won.connect(
		func(context: RewardContext):
			if available:
				context.extra_relic_count += 2
				available = false
	)
