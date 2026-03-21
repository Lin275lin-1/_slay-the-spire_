extends EnemyAction

@export var block := 10
@export var damage:= 3

func perform_action() -> void:
	if not enemy or not target:
		return
		
	var block_effect := BlockEffect.new()
	var attack_effect := AttackEffect.new()
	block_effect.execute(GainBlockContext.new(enemy, [enemy], block))
	attack_effect.sound = intent.sound
	attack_effect.execute(DamageContext.new(enemy, [target], damage))
		
