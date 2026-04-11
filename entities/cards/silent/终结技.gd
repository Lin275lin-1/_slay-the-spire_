# 记得删掉class_name
# !!一定记得把脚本附加到cardname.tres上
extends Card

func apply_effects(source: Player, targets: Array[Node]) -> void:
	var numeric_entries := get_numeric_entries()
	var damage_effect := AttackEffect.new()
	for i in range(get_numeric_value(numeric_entries[1], source)):
		damage_effect.execute(DamageContext.new(source, targets, get_numeric_value(numeric_entries[0]), get_enchantment_modifiers(numeric_entries[0])))
		await source.get_tree().create_timer(0.2).timeout
		
func get_description(source_: Creature, target_: Creature) -> String:
	var numeric_dict := get_final_values(source_, target_)
	var final_value: int
	var color: String
	var replacement: String
	var ret: String = _get_default_description() + "[center](造成{damage}点伤害{times}次。)[/center]"
	for placeholder: String in numeric_dict.keys():
		final_value = numeric_dict[placeholder]
		replacement = str(final_value)
		for numeric_entry in get_numeric_entries():
			if numeric_entry.placeholder == placeholder:
				if numeric_entry.base_value == final_value:
					continue
				elif numeric_entry.base_value > final_value:
					color = "red"
					replacement = "[color={0}]{1}[/color]".format([color, final_value])
				elif numeric_entry.base_value < final_value:
					color = "green"
					replacement = "[color={0}]{1}[/color]".format([color, final_value])
				ret = ret.replace("{" + placeholder + "}", replacement)
	return append_features(ret).format(numeric_dict)
