extends Card
	
func apply_effects(source: Player, targets: Array[Node]) -> void:
	var draw_effect = DrawCardEffect.new()
	draw_effect.execute(DrawCardContext.new(source, targets, get_numeric_value(get_numeric_entries()[0])))
	var buff_effect = ApplyBuffEffect.new()
	buff_effect.execute(ApplyBuffContext.new(source, targets, 1, NoDrawDebuff.new()))
