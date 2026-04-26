extends Relic

func initialize_relic(owner: RelicUI) -> void:
	Events.combat_room_entered.connect(_on_combat_room_entered.bind(owner))
	
func _on_combat_room_entered(room: Room, _run_stats: RunStats, char_stats: CharacterStats) -> void:
	var encounter := room.enemy_encounter
	if encounter and encounter.type == EnemyEncounter.Type.BOSS:
		char_stats.health += 25
