extends Enchantment

func get_modifiers() -> Array[Modifier]:
	return [Modifier.new(Enums.NumericType.BLOCK, stacks, 1.0, null)]

func get_description() -> String:
	return description.format({"stacks": stacks})

# 只有带有格挡数字的卡牌才能获得该附魔
func can_enchant(card: Card) -> bool:
	if card.has_enchantment():
		return false
	for entry: NumericEntry in card.get_numeric_entries():
		if entry.type == Enums.NumericType.BLOCK:
			return true
	return false
