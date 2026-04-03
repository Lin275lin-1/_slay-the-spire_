extends Relic

var used := false

func initialize_relic(_owner: RelicUI) -> void:
	Events.combat_won.connect(func(): used = false)
	
func activate_relic(owner: RelicUI) -> void:
	if not used:
		_add_mana(owner)
		used = true

func deactivate_relic(_owner: RelicUI) -> void:
	pass


func _add_mana(owner: RelicUI) -> void:
	owner.flash()
	var player := owner.get_tree().get_first_node_in_group("ui_player") as Player
	if player:
		player.stats.energy += 1
