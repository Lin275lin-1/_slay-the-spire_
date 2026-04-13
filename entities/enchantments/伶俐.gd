extends Enchantment

func get_modifiers() -> Array[Modifier]:
	return []

func on_play(player: Player, _targets: Array[Node]) -> void:
	player.gain_block(GainBlockContext.new(player, [player], stacks))

func get_description() -> String:
	return description.format({"stacks": stacks})

func get_additional_card_description() -> String:
	return "[p][center]获得{stacks}点格挡。[/center]".format({"stacks": stacks})
