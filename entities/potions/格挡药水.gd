extends Potion

func play(source, targets: Array[Node]) -> void:
	var block_effect = BlockEffect.new()
	block_effect.block_provider = NumericProvider.new(12)
	block_effect.target_type = Effect.TargetType.SELF
	block_effect.execute(source, {}, null)
