class_name GainEnergyEffect
extends Effect

@export var energy_provider: NumericProvider

func apply(source: Node, _targets: Array[Node], card_context: Dictionary, previous_result: Variant = null) -> Variant:
	var value = energy_provider.get_value(previous_result, card_context)
	source = source as Creature
	if source is Player:
		source.gain_energy(GainEnergyContext.new(value))
	return null
