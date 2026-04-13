# 记得删掉class_name
# !!一定记得把脚本附加到cardname.tres上
extends Card

func apply_effects(source: Player, targets: Array[Node]) -> void:
	var apply_buff_effect := ApplyBuffEffect.new()
	apply_buff_effect.sound = sound
	apply_buff_effect.execute(ApplyBuffContext.new(source, \
	targets, get_numeric_value(get_numeric_entries()[0]), DexterityBuff.new()))
	
