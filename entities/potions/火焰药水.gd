extends Potion


func play(targets: Array[Node]) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.execute(DamageContext.new(null, targets, 20, [], true))
