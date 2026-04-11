# 记得删掉class_name
# !!一定记得把脚本附加到cardname.tres上
extends Card

func apply_effects(source: Player, targets: Array[Node]) -> void:
	var numeric_entries := get_numeric_entries()
	var damage_effect := DamageEffect.new()
	damage_effect.sound = sound
	damage_effect.execute(DamageContext.new(source, targets, get_numeric_value(numeric_entries[0]), get_enchantment_modifiers(numeric_entries[0])))
	
