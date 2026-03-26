class_name CardRewards

extends TextureRect

signal card_reward_selected(card:Card)
const CARD_MENU_UI=preload("res://scenes/ui/card_menu_ui.tscn")
@export var rewards:Array[Card]:set = set_rewards
@onready var cards:HBoxContainer =%Cards
@onready var skip_card_reward: Button =%SkipCardsReward
@onready var card_tooltip_popup:ToolTip = $ToolTip

#@onready var take_button: Button = %TakeButton
var selected_card:Card
func _ready()->void:
	_clear_rewards()
	#take_button.pressed.connect(
		#func():
			#card_reward_selected.emit(selected_card)
			#print("drafted %s"% selected_card.id)
			#queue_free()
	#)
	skip_card_reward.mouse_entered.connect(_on_skip_button_entered)
	skip_card_reward.mouse_exited.connect(_on_skip_button_exited)
	
	skip_card_reward.pressed.connect(
		func():
			card_reward_selected.emit(null)
			print("skipped card reward")
			queue_free()
	)
	
	#var test_cards: Array[Card] = []
	#for i in range(3):
		#var test_card = Card.new()
		#test_card.id = "test_%d" % i
		#test_card.description = "测试卡牌描述 %d\n1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11" % i
		#test_cards.append(test_card)
	#set_rewards(test_cards)
	
func _on_skip_button_entered():
	skip_card_reward.self_modulate = Color(0.7, 0.7, 0.7)

func _on_skip_button_exited():
	skip_card_reward.self_modulate = Color.WHITE
	
func _input(event:InputEvent)->void:
	if event.is_action_pressed("ui_cancel"):
		
		card_tooltip_popup.hide_tooltip()
func _clear_rewards()->void:
	for card: Node in cards.get_children():
		card.queue_free()
		
		card_tooltip_popup.hide_tooltip()
		
		selected_card = null
		
#func _show_tooltip(card: Card)->void:
	#selected_card = card
	#card_tooltip_popup.show_tooltip(card)
	
	
#func set_rewards(new_cards:Array[Card])->void:
	#rewards=new_cards
	#if not is_node_ready():
		#await ready
	#_clear_rewards()
	#for card:Card in rewards:
		#var new_card:=CARD_MENU_UI.instantiate() as CardMenuUI
		#cards.add_child(new_card)
		#new_card.card= card
		#new_card.tooltip_requested.connect(_show_tooltip)
		
		
# 显示 Tooltip（通过 bind 传入了卡牌节点）
func _show_tooltip(card: Card, card_node: Node) -> void:
	#+ Vector2(card_node.size.x, 0)
	var tooltip_position = card_node.global_position + Vector2(card_node.size.x+50, 0)
	card_tooltip_popup.show_tooltip(card.description, tooltip_position)

# 隐藏 Tooltip
func _hide_tooltip() -> void:
	card_tooltip_popup.hide_tooltip()

# 点击卡牌时调用
func _on_card_selected(card: Card) -> void:
	card_reward_selected.emit(card)
	queue_free()
	#selected_card = card
	
	#take_button.pressed.emit()   # 触发 take 逻辑

func set_rewards(new_cards: Array[Card]) -> void:
	rewards = new_cards
	if not is_node_ready():
		await ready
	_clear_rewards()
	for card in rewards:
		var new_card := CARD_MENU_UI.instantiate() as CardMenuUI
		cards.add_child(new_card)
		new_card.card = card
		# 绑定卡牌节点以便获取位置
		new_card.tooltip_requested.connect(_show_tooltip.bind(new_card))
		new_card.tooltip_hide_requested.connect(_hide_tooltip)
		new_card.inspect_card_requested.connect(_on_card_selected)
		#print("Added card: ", card.id)  # 调试
