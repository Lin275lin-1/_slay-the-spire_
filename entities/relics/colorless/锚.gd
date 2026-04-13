extends Relic

@export var blocks: int
var used = false

func initialize_relic(_owner: RelicUI) -> void:
	Events.combat_won.connect(func(): used = false)
	
func activate_relic(owner: RelicUI) -> void:
	if used:
		return
	var gain_block_effect := BlockEffect.new()
	gain_block_effect.block_provider = NumericProvider.new(blocks)
	gain_block_effect.no_modifiers = true
	gain_block_effect.target_type = Effect.TargetType.SELF
	gain_block_effect.execute(owner.get_tree().get_first_node_in_group('ui_player'))
	used = true
	
func deactivate_relic(_owner: RelicUI) -> void:
	pass
