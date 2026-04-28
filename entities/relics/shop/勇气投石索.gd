extends Relic

var available := false

func initialize_relic(_owner: RelicUI) -> void:
	Events.combat_room_entered.connect(
		func(room: Room, _run_stats: RunStats, _char_stats: CharacterStats):
		if room.enemy_encounter.type == EnemyEncounter.Type.ELITE:
			available = true
		else:
			available = false
		)
	
func activate_relic(owner: RelicUI) -> void:
	if available:
		super.activate_relic(owner)
