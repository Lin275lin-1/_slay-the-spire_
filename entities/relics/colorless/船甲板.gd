extends Relic

var turn = 0

func initialize_relic(_owner: RelicUI) -> void:
	Events.combat_won.connect(func(): turn = 0)
	
func activate_relic(owner: RelicUI) -> void:
	turn += 1
	if turn == 2:
		super.activate_relic(owner)
	
func deactivate_relic(_owner: RelicUI) -> void:
	pass
