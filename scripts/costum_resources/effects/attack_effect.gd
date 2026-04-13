class_name AttackEffect
extends Effect

var no_modifiers: bool

func execute(context: Context) -> int:
	var total_damage := 0
	for target: Creature in context.targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			SFXPlayer.play(sound)
			total_damage += target.attack(context)
	return total_damage
