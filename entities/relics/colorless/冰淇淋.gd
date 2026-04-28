extends Relic

var energy_count := 0

func initialize_relic(owner: RelicUI) -> void:
	Events.combat_won.connect(func(_context: RewardContext): energy_count = 0)
	Events.player_turn_started.connect(
		func():
			# 很怪,而且没有使用effect
			var player: Player = owner.get_tree().get_first_node_in_group("ui_player")
			player.gain_energy(GainEnergyContext.new(energy_count))
	)
	Events.player_turn_ended.connect(
		func():
			var player: Player = owner.get_tree().get_first_node_in_group("ui_player")
			energy_count = player.stats.energy
	)
	
