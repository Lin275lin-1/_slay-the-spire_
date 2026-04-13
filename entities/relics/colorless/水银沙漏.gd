extends Relic

@export var damage := 3
@export var sound: AudioStream

func activate_relic(owner: RelicUI) -> void:
	var damage_effect = DamageEffect.new()
	damage_effect.sound = sound
	damage_effect.execute(DamageContext.new(owner, owner.get_tree().get_nodes_in_group("ui_enemies"), damage, [], true))
	owner.flash()
