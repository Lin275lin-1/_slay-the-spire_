extends Enchantment

func get_modifiers() -> Array[Modifier]:
	return []

func on_play(player: Player, _targets: Array[Node]) -> void:
	player.gain_block(GainBlockContext.new(player, player, stacks, [], true))

func get_description() -> String:
	return description.format({"stacks": stacks})

func get_additional_card_description() -> String:
	return "[p][center][color=purple]获得{stacks}点格挡。[/color][/center]".format({"stacks": stacks})
