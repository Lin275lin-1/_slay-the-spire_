extends Card

#func apply_effects(context: Context) -> void:
	


func apply_effects(source: Player, targets: Array[Node]) -> void:
	# 造成6点伤害
	var attack_effect := AttackEffect.new()
	attack_effect.sound = sound
	attack_effect.execute(DamageContext.new(source, targets, get_numeric_value(get_numeric_entries(), 0)))
	# 这个真的需要effect?
	source.put_card_in_discard_pile(self.duplicate())
