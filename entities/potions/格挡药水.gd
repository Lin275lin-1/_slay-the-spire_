extends Potion

func play(targets: Array[Node]) -> void:
	var block_effect = BlockEffect.new()
	block_effect.execute(GainBlockContext.new(null, targets, 12, [], true))
