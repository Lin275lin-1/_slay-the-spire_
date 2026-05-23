extends Relic

var potion: Potion

func initialize_relic(_owner: RelicUI) -> void:
	Events.combat_room_entered.connect(_on_combat_room_entered)
	potion = ItemPool.get_special_potion_by_name("药水形状的石头")
	
func _on_combat_room_entered(_room: Room, run_stats: RunStats, _char_stats: CharacterStats) -> void:
	if potion:
		run_stats.add_potion(potion.duplicate())
