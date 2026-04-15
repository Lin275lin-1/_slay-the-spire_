extends Relic

@export var damage := 3
@export var sound: AudioStream

func activate_relic(owner: RelicUI) -> void:
	var damage_effect = DamageEffect.new()
	damage_effect.damage_provider = NumericProvider.new(3)
	damage_effect.target_type = Effect.TargetType.ALL_ENEMIES
	damage_effect.execute(owner, {"player": owner.get_tree().get_first_node_in_group("ui_player")}, null)
	owner.flash()
