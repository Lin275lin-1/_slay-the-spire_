extends Enchantment

func get_modifiers() -> Array[Modifier]:
	return [Modifier.new(Enums.NumericType.DAMAGE, stacks, 1.0, null)]

func get_description() -> String:
	return description.format({"stacks": stacks})
