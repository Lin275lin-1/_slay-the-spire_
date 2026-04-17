class_name HellRaiserBuff
extends Buff
	
func initialize() -> void:
	if agent and agent.has_signal("after_draw_card"):
		agent.connect("after_draw_card", _on_after_draw_card)


func _on_after_draw_card(context: DrawCardContext) -> void:
	var card = context.card
	if card and card.id.contains("打击"):
		var enemies: Array[Node] = agent.get_tree().get_nodes_in_group("ui_enemies")
		enemies = enemies.filter(func(enemy: Enemy): return is_instance_valid(enemy) and !enemy.dead)
		if enemies.is_empty():
			return
		if card.get_target() == card.Target.SINGLE_ENEMY:
			enemies = [enemies[randi() % len(enemies)]]
		card.first_play_free = true
		card.play(agent, enemies)
		context.card = null
