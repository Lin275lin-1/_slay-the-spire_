extends EnemyAction

@export var damage:= 3

# 条件行为必须实现该函数
func is_performable() -> bool:
	return false

func perform_action() -> void:
	if not enemy or not target:
		return
	var attack_effect := AttackEffect.new()
	attack_effect.sound = intent.sound
	var tween := create_tween()
	var damage_context := DamageContext.new(enemy, [target], damage)
	tween.tween_callback(attack_effect.execute.bind(damage_context))
	tween.tween_interval(0.3)
	tween.tween_callback(attack_effect.execute.bind(damage_context))
	await tween.finished
