class_name AggressionBuff
extends Buff

#enum Where{
	#HAND, # 手牌
	#DRAW_PILE, # 抽牌堆
	#DISCARD_PILE # 弃牌堆
#}
#
#enum SelectionMode{
	#MANUAL,
	#ALL,
	#RANDOM, # 随机卡牌，取决于max_select
	#FIRST, # 第一张（牌库顶
	#ALL_NOT_UPGRADED, #所有未升级的卡牌
#}
#
#@export var where: Where
#@export var selectionMode: SelectionMode
#@export var min_select: int = 0
#@export var max_select: int = 0
#@export var filter_condition: CardCondition
#@export var deck_view_selection_mode: DeckView.SelectionMode = DeckView.SelectionMode.SELECT
### 消耗，升级等
#@export var callback_hint: String
func initialize() -> void:
	if agent is Player:
		Events.player_hand_drawn.connect(_on_player_hand_drawn)
		
func get_modifier() -> Array[Modifier]:
	return []

func _on_player_hand_drawn() -> void:
	var effects: Array[Effect] = []
	
	var select_card_effect := SelectCardEffect.new() 
	select_card_effect.where = SelectCardEffect.Where.DISCARD_PILE
	select_card_effect.selectionMode = SelectCardEffect.SelectionMode.RANDOM
	select_card_effect.max_select = 1
	select_card_effect.filter_condition = CardCondition.new(CardCondition.Type.IS_ATTACK)
	
	var foreach_card_effect := ForeachCardEffect.new()
	foreach_card_effect.effects = [ModifyCardFlagEffect.new(ModifyCardFlagEffect.FlagName.UPGRADED, true)\
	,PutCardToPileEffect.new(PutCardToPileEffect.TargetPile.HAND, false)]
	
	effects.append(select_card_effect)
	effects.append(foreach_card_effect)
	
	var last = null
	for effect:Effect in effects:
		last = await effect.execute(agent, {}, last)
	
