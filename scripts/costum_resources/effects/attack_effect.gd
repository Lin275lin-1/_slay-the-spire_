class_name AttackEffect
extends Effect

var no_modifiers: bool

func execute(context: Context) -> void:
	if not context.source or not context.targets:
		return 
	SFXPlayer.play(sound)
	context.source.attack(context)
