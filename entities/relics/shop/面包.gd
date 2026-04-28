extends Relic

var turn = 0

func initialize_relic(_owner: RelicUI) -> void:
	Events.combat_won.connect(func(_context: RewardContext): turn = 0)
	
func activate_relic(owner: RelicUI) -> void:
	turn += 1
	if turn == 1:
		var player = owner.get_tree().get_first_node_in_group("ui_player") as Player
		if player:
			player.stats.energy -= 2
	else:
		super.activate_relic(owner)
