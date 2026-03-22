extends EnemyAction

@export var damage := 7

func perform_action() -> void:
	if not enemy or not target:
		return 
	
	var attack_effect := AttackEffect.new()
	attack_effect.sound = intent.sound
	attack_effect.execute(DamageContext.new(enemy, [target], damage))
