class_name LossHealthEffect
extends Effect

func execute(context: Context) -> Variant:
	for target: Creature in context.targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			target.lose_health(context)
			SFXPlayer.play(sound)
	return null
