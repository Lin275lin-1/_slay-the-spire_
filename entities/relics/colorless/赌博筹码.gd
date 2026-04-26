extends Relic

var used := false

func initialize_relic(owner: RelicUI) -> void:
	Events.player_hand_drawn.connect(_on_player_hand_drawn.bind(owner))	
	Events.combat_won.connect(func(): used = false)
	
func _on_player_hand_drawn(owner: RelicUI) -> void:
	if not used:
		activate_relic(owner)
		used = true
