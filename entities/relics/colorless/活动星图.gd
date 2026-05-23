extends Relic

func initialize_relic(_owner: RelicUI) -> void:
	Events.unknown_room_entered.connect(
		func(_room: Room, _run_stats: RunStats, char_stats: CharacterStats):
		char_stats.health += 5
		)
