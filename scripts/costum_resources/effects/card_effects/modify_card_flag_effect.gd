class_name ModifyCardFlagEffect
extends CardEffect

enum FlagName{
	NONE,
	FIRST_PLAY_FREE,
	EXHAUST,
	ETHEREAL,
	SLY,
	UPGRADED
}

@export var flag_name: FlagName = FlagName.NONE
@export var value: bool = false

func _init(flag_name_: FlagName = FlagName.NONE, value_: bool = false) -> void:
	flag_name = flag_name_
	value = value_

func execute(source: Node, card_context: Dictionary = {}, _previous_result: Variant = null) -> Variant:
	var card = (card_context.get("target_card", null) as Card)
	source = (source as Player)
	if card:
		match flag_name:
			FlagName.FIRST_PLAY_FREE:
				card.first_play_free = value
			FlagName.EXHAUST:
				card.exhaust = value
			FlagName.ETHEREAL:
				card.ethereal = value
			FlagName.SLY:
				card.sly = value
			FlagName.UPGRADED:
				if !card.upgraded and value:
					card.upgrade()
				else:
					card.upgraded = value
		if card_context.get("source_pile", null) == SelectCardEffect.Where.HAND:
			source.agent.update_hand()
	return null
