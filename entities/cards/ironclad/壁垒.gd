extends Card
	
#func apply_effects(source: Player, targets: Array[Node]) -> void:
	#var buff_effect := ApplyBuffEffect.new()
	#buff_effect.sound = sound
	#buff_effect.execute(ApplyBuffContext.new(source, targets, 1, BarricadeBuff.new()))
