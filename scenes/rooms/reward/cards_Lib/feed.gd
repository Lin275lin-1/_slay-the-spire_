extends Card

func apply_effects(context: Context) -> void:
	# 造成10点伤害
	var attack_effect := AttackEffect.new()
	context.amount = 10
	attack_effect.sound = sound
	attack_effect.execute(context)
	
	# 若击杀敌人，永久增加3点最大生命值（需要判断目标是否死亡）
	var target = context.targets[0]
	#if target.is_dead():
		#var max_hp_effect = IncreaseMaxHPEffect.new()
		#max_hp_effect.execute(IncreaseMaxHPContext.new(context.source, 3))
