class_name UnmovableBuff
extends Buff

var available: bool = false
var used: bool = false

func initialize() -> void:
	if agent is Player:
		Events.before_card_played.connect(_on_before_card_played)
		agent.before_gain_block.connect(_on_before_gain_block)	
		agent.turn_ended.connect(_on_turn_ended)
		
func get_description() -> String:
	return description
		
func get_modifier() -> Array[Modifier]:
	if not used:
		var modifier := Modifier.new(Enums.NumericType.BLOCK, 0, 2.0, null)
		return [modifier]
	return []
	
func _on_before_gain_block(context: Context) -> void:
	if not used and available:
		context.modifiers.append(Modifier.new(Enums.NumericType.BLOCK, 0, 2.0, null))
		used = true

func _on_turn_ended(_creature: Creature) -> void:
	used = false
	available = false

func _on_before_card_played(card: Card, _card_context: Dictionary) -> void:
	for effect: Effect in card.get_effects():
		if effect is BlockEffect:
			available = true
			break
