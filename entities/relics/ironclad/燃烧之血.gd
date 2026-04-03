extends Relic

@export var heal_amount := 6

func initialize_relic(_owner: RelicUI) -> void:
	pass
	
func activate_relic(owner: RelicUI) -> void:
	var player := owner.get_tree().get_first_node_in_group("ui_player") as Player
	if player:
		player.stats.heal(heal_amount)
		owner.flash()

func deactivate_relic(_owner: RelicUI) -> void:
	pass
