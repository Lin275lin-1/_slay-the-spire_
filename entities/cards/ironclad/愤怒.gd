extends Card

#func apply_effects(context: Context) -> void:
	


#func apply_effects(source: Player, targets: Array[Node]) -> void:
	#var numeric_entries = get_numeric_entries()
	#var attack_effect := AttackEffect.new()
	#attack_effect.sound = sound
	#var damage_context = DamageContext.new(source, targets, get_numeric_value(numeric_entries[0]))
	#damage_context.modifiers.append_array(get_enchantment_modifiers(numeric_entries[0]))
	#attack_effect.execute(damage_context)
	## 这个真的需要effect?
	#source.put_card_in_discard_pile(self.duplicate())
