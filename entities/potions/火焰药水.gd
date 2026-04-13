extends Potion


func play(source: Node, targets: Array[Node]) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.damage_provider = NumericProvider.new(20)
	damage_effect.target_type = Effect.TargetType.SINGLE_ENEMY
	damage_effect.execute(source, {}, null)
