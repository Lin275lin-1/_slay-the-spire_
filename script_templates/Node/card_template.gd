# meta-name: 卡牌逻辑
# meta-description: 卡牌逻辑脚本的模板
# 记得删掉class_name
# !!一定记得把脚本附加到cardname.tres上
class_name MyCard
extends Card

func apply_effects(source: Player, targets: Array[Node]) -> void:
	var damage_effect := AttackEffect.new()
	damage_effect.sound = sound
	damage_effect.execute(DamageContext.new(source, targets, get_numeric_value(get_numeric_entries(), 0)))
	
