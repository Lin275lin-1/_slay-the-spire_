extends Card

func get_description(source_: Creature, target_: Creature) -> String:
	var numeric_dict := get_final_values(source_, target_)
	var final_value: int
	var color: String
	var replacement: String
	var ret: String = _get_default_description() + "[p][center](造成{damage}点伤害。)[/center]"
	for placeholder: String in numeric_dict.keys():
		final_value = numeric_dict[placeholder]
		replacement = str(final_value)
		for numeric_entry in get_numeric_entries():
			if numeric_entry.placeholder == placeholder:
				if numeric_entry.get_base_value() == final_value:
					continue
				elif numeric_entry.get_base_value() > final_value:
					color = "red"
					replacement = "[color={0}]{1}[/color]".format([color, final_value])
				elif numeric_entry.get_base_value() < final_value:
					color = "green"
					replacement = "[color={0}]{1}[/color]".format([color, final_value])
				ret = ret.replace("{" + placeholder + "}", replacement)
	return append_features(ret).format(numeric_dict)
