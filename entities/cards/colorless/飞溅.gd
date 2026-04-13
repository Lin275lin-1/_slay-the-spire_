# 记得删掉class_name
# !!一定记得把脚本附加到cardname.tres上
extends Card

func apply_effects(source: Player, targets: Array[Node]) -> void:
	var discover_effect = DiscoverEffect.new()
	var color_mask = 0b0011111
	var rarity_mask = 0b00111
	if upgraded:
		discover_effect.execute(DiscoverContext.new(source, targets, color_mask - source.stats.color, Type.ATTACK, rarity_mask, true, true, true))
	else:
		discover_effect.execute(DiscoverContext.new(source, targets, color_mask - source.stats.color, Type.ATTACK, rarity_mask, true, false, true))
