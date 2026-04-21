class_name BattleReward
extends Control

#relic暂时不删
enum Type {GOLD, NEW_CARD, RELIC}

const CARD_REWARDS=preload("res://scenes/rooms/reward/card_rewards.tscn")

const CARD_MENU_UI = preload("res://scenes/ui/card_menu_ui.tscn")

const REWARD_BUTTON=preload("res://scenes/rooms/reward/reward_button.tscn")
const GOLD_ICON:= preload("res://images/ui/reward_screen/reward_icon_money.png")
const GOLD_TEXT := "%s gold"
const CARD_ICON:= preload("res://images/ui/reward_screen/reward_icon_card.png")
const CARD_TEXT :="Add New Card"

@export var run_stats: RunStats
@export var character_stats:CharacterStats

@onready var rewards:VBoxContainer =%rewards
@onready var return_button := $Loot/Button

var card_reward_total_weight :=8.8
var card_rarity_weights :={
	Card.Rarity.COMMON:0.0,
	Card.Rarity.UNCOMMON: 0.0,
	Card.Rarity.RARE:0.0
}


func _ready()->void:
	for node:Node in rewards.get_children():
		node.queue_free()

	if run_stats:
		run_stats.gold_changed.connect(func(): print("gold:%s" % run_stats.gold))
	return_button.mouse_entered.connect(_on_return_button_entered)
	return_button.mouse_exited.connect(_on_return_button_exited)
	
	#add_gold_reward(77)
	#add_card_reward()
	

func _on_return_button_entered():
	return_button.scale = Vector2(1.1, 1.1)

func _on_return_button_exited():
	return_button.scale = Vector2(1, 1)
	
func add_gold_reward(amount:int)->void:
	var gold_reward:=REWARD_BUTTON.instantiate()as RewardButton
	gold_reward.reward_icon=GOLD_ICON
	gold_reward.reward_text =GOLD_TEXT % amount
	gold_reward.pressed.connect(_on_gold_reward_taken.bind(amount))
	rewards.add_child.call_deferred(gold_reward)
	
func _on_gold_reward_taken(amount: int) -> void:
	if not run_stats:
		return
	run_stats.gold += amount
#回退
func _on_button_pressed() -> void:
	Events.combat_reward_exited.emit()

func add_card_reward()->void:
	var card_reward := REWARD_BUTTON.instantiate() as RewardButton
	card_reward.reward_icon=CARD_ICON
	card_reward.reward_text =CARD_TEXT
	card_reward.pressed.connect(_show_card_rewards)
	rewards.add_child.call_deferred(card_reward)
	
func _show_card_rewards()->void:
	if not run_stats or not character_stats:
		return
	var card_rewards := CARD_REWARDS.instantiate() as CardRewards
	add_child(card_rewards)
	card_rewards.card_reward_selected.connect(_on_card_reward_taken)
	
	var card_reward_array:Array[Card]=[]
	var available_cards:Array[Card]=character_stats.draftable_cards.cards.duplicate(true)
	
	for i in run_stats.card_rewards:

		_setup_card_chances()
		var roll:=randf_range(0.0,card_reward_total_weight)
		for rarity:Card.Rarity in card_rarity_weights:
			if card_rarity_weights[rarity]>roll:
				_modify_weights(rarity)
				var picked_card:=_get_random_available_card(available_cards,rarity)
				card_reward_array.append(picked_card)
				available_cards.erase(picked_card)
				break
	card_rewards.rewards=card_reward_array
	card_rewards.show()

func _setup_card_chances()->void:

	card_reward_total_weight=run_stats.common_weight +run_stats.uncommon_weight+run_stats.rare_weight
	card_rarity_weights[Card.Rarity.COMMON]=run_stats.common_weight
	card_rarity_weights[Card.Rarity.UNCOMMON]=run_stats.common_weight+run_stats.uncommon_weight
	card_rarity_weights[Card.Rarity.RARE]=card_reward_total_weight
	
	
func _modify_weights(rarity_rolled:Card.Rarity)->void:
	if rarity_rolled== Card.Rarity.RARE:
		run_stats.rare_weight =RunStats.BASE_RARE_WEIGHT
	else:
		run_stats.rare_weight=clampf(run_stats.rare_weight+0.3,run_stats.BASE_RARE_WEIGHT,5.0)
		

func _get_random_available_card(available_cards:Array[Card],with_rarity:Card.Rarity)->Card:
	var all_possible_cards := available_cards.filter(
		func(card: Card) -> bool:
			return card.rarity == with_rarity
	)
	if all_possible_cards.is_empty():
		printerr("No card of rarity %s available" % Card.Rarity.keys()[with_rarity])
		# 降级：如果可用卡牌非空，返回任意一张卡牌（可选）
		if not available_cards.is_empty():
			return available_cards.pick_random()
		return null
	return all_possible_cards.pick_random()
	
func _on_card_reward_taken(card:Card)->void:
	if not character_stats or not card:
		return
	#print("DeckBefore:\n%s\n" % character_stats.deck)
#	卡牌复制
	character_stats.deck.add_card(card.duplicate())
	#print("DeckAfter:\n%s" % character_stats.deck)
