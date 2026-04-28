extends Relic

var available := false

func initialize_relic(_owner: RelicUI) -> void:
	Events.combat_won.connect(
		func(context: RewardContext):
			if available:
				context.upgrade_all = true
				available = false
	)

func activate_relic(owner: RelicUI) -> void:
	var player = owner.get_tree().get_first_node_in_group("ui_player") as Player
	if player and player.player_hit_this_combat == 0:
		available = true
		owner.flash()
	else:
		available = false
