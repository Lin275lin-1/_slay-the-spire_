extends Relic

var turn = 0

func initialize_relic(_owner: RelicUI) -> void:
	Events.combat_won.connect(func(_context: RewardContext): turn = 0)
	
func activate_relic(owner: RelicUI) -> void:
	turn += 1
	if turn == 2:
		super.activate_relic(owner)
