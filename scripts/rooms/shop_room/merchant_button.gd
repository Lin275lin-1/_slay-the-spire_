extends Control

@onready var inventory := %MerchantInventory
@onready var highlight_polygon := $HighlightPolygon as Line2D

const CARD_MENU_UI_SCENE = preload("res://scenes/ui/card_menu_ui.tscn")

var slots_container: Control
var back_button: Control
var backstop: ColorRect
var is_hovered := false
var back_button_hovered := false

#商人手部
var merchant_hand: SpineSprite
var hand_hide_timer: Timer
var hand_shake_timer: Timer
var base_hand_pos: Vector2
var current_shake_tween: Tween
var hand_move_tween: Tween   # 用于保存手部移动动画

func _ready() -> void:
#	商人初始动画
	$MerchantVisual.get_animation_state().set_animation("idle_loop", true, 0)

	hand_hide_timer = Timer.new()
	hand_hide_timer.one_shot = true
	hand_hide_timer.wait_time = 3.0
	hand_hide_timer.timeout.connect(_on_hand_hide_timeout)
	add_child(hand_hide_timer)


	hand_shake_timer = Timer.new()
	hand_shake_timer.wait_time = 0.03
	hand_shake_timer.timeout.connect(_apply_hand_shake)
	add_child(hand_shake_timer)

	if highlight_polygon:
		highlight_polygon.modulate.a = 0.0

	if inventory:
		backstop = inventory.get_node("Backstop") as ColorRect
		slots_container = inventory.get_node("SlotsContainer") as Control
		back_button = inventory.get_node("BackButton") as Control
		merchant_hand = inventory.get_node_or_null("MerchantHandContainer") as SpineSprite

		if back_button:
			back_button.visible = false

		if slots_container:
			_set_slots_initial_position(slots_container)
		else:
			print("错误：未找到 SlotsContainer 节点！")

func _populate_cards() -> void:
	if not slots_container:
		print("错误:SlotsContainer节点为空")
		return
	var character_cards = slots_container.get_node_or_null("CharacterCards")
	if not character_cards:
		print("错误:character_cards节点为空")
		return

	var card_pile = preload("res://entities/characters/ironclad/ironclad_starting_deck.tres")
	if not card_pile:
		print("错误:card_pile为空")
		return
	var available_cards = card_pile.cards

	var slot_index := 0
	for child in character_cards.get_children():
		if slot_index >= available_cards.size():
			break

		if child is MerchantCard:
			var card_data = available_cards[slot_index]
			child.card_data = card_data

			if not child.card_clicked.is_connected(_on_card_purchased):
				child.card_clicked.connect(_on_card_purchased)
			if not child.hand_hover_requested.is_connected(_on_hand_hover):
				child.hand_hover_requested.connect(_on_hand_hover)
			if not child.hand_hide_requested.is_connected(_on_hand_hide):
				child.hand_hide_requested.connect(_on_hand_hide)
			slot_index += 1

	print("实际填充卡牌数量：", slot_index)

func _on_card_purchased(card: Card) -> void:
	print("购买卡牌：", card.id)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var global_mouse_pos = event.global_position

		var local_event = make_input_local(event)
		if local_event is InputEventMouseMotion:
			var inside_merchant = Rect2(Vector2.ZERO, size).has_point(local_event.position)
			if inside_merchant != is_hovered:
				is_hovered = inside_merchant
				_set_hover_effect(inside_merchant)

		if back_button and back_button.visible:
			var back_rect = Rect2(back_button.global_position, back_button.size)
			var inside_back = back_rect.has_point(global_mouse_pos)
			if inside_back != back_button_hovered:
				back_button_hovered = inside_back
				_set_back_button_scale(inside_back)
		return

	if not (event is InputEventMouseButton):
		return
	if event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
		return

	if back_button and back_button.visible:
		var back_rect = Rect2(back_button.global_position, back_button.size)
		if back_rect.has_point(event.global_position):
			print("返回按钮被点击")
			_on_back_button_pressed()
			accept_event()
			return

	if not (back_button and back_button.visible):
		var local_event = make_input_local(event)
		if local_event is InputEventMouseButton:
			if Rect2(Vector2.ZERO, size).has_point(local_event.position):
				print("商人被点击！")
				_show_inventory()
				accept_event()

func _set_back_button_scale(active: bool) -> void:
	if not back_button:
		return
	var target_scale = Vector2(1.2, 1.2) if active else Vector2.ONE
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(back_button, "scale", target_scale, 0.15)

func _set_hover_effect(active: bool) -> void:
	if not highlight_polygon:
		return
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(highlight_polygon, "modulate:a", 1.0 if active else 0.0, 0.15)

func _set_slots_initial_position(slots: Control) -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	var target_x = (viewport_size.x - slots.size.x) / 2
	var target_y = 0
	var target_position = Vector2(target_x, target_y)
	slots.set_meta("target_position", target_position)
	slots.position = Vector2(target_x, -slots.size.y)

func _show_inventory() -> void:
	if not slots_container:
		print("slots_container 未初始化")
		return
	slots_container.visible = true

	var root = get_tree().root
	if slots_container.get_parent() != root:
		var original_parent = slots_container.get_parent()
		if original_parent:
			original_parent.remove_child(slots_container)
		root.add_child(slots_container)
	slots_container.z_index = 3

	var target_position: Vector2 = slots_container.get_meta("target_position", Vector2.ZERO)

	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(slots_container, "position", target_position, 0.5)

	slots_container.modulate.a = 0.0
	tween.parallel().tween_property(slots_container, "modulate:a", 1.0, 0.3)

	if back_button:
		back_button.visible = true

	if backstop:
		backstop.visible = true
		var tween_mask = create_tween()
		tween_mask.tween_property(backstop, "modulate:a", 0.7, 0.3)

	print("动画开始位置:", slots_container.position, "目标位置:", target_position)
	_populate_cards()

func _on_back_button_pressed() -> void:
	if not slots_container:
		return

	# --- 修复：立即强制复位商人的手，防止残留动画干扰 ---
	if merchant_hand:
		if hand_hide_timer:
			hand_hide_timer.stop()
		_stop_shake()
		merchant_hand.position = Vector2(234, -54)

	# 库存滑出动画
	var target_y = -slots_container.size.y
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(slots_container, "position:y", target_y, 0.4)
	tween.parallel().tween_property(slots_container, "modulate:a", 0.0, 0.3)

	if backstop:
		var tween_mask = create_tween()
		tween_mask.tween_property(backstop, "modulate:a", 0.0, 0.3)
		tween_mask.tween_callback(func(): backstop.visible = false)

	tween.tween_callback(_reset_inventory_position)

func _reset_inventory_position() -> void:
	if slots_container.get_parent() != inventory:
		slots_container.get_parent().remove_child(slots_container)
		inventory.add_child(slots_container)
	slots_container.visible = false
	back_button.visible = false

func _on_back_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("返回按钮被点击")
		_on_back_button_pressed()
		accept_event()

# ---------- 手部悬停与缓慢抖动 ----------
func _on_hand_hover(card_node: Node) -> void:
	if not merchant_hand:
		return
	# 取消延迟隐藏
	#if hand_hide_timer:
		#hand_hide_timer.stop()

	# 停止之前的抖动
	_stop_shake()

	# 计算基准位置（卡牌中心偏上）
	var card_center = card_node.global_position + card_node.size * card_node.scale * 0.5
	base_hand_pos = card_center + Vector2(-60, -200)

	# 平滑移动到基准位置，移动完成后再启动抖动
	hand_move_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	hand_move_tween.tween_property(merchant_hand, "global_position", base_hand_pos, 2)
	hand_move_tween.tween_callback(_start_shake)

	merchant_hand.visible = true

func _start_shake() -> void:
	# 确保计时器停止后再启动
	hand_shake_timer.stop()
	hand_shake_timer.start()

func _stop_shake() -> void:
	hand_shake_timer.stop()
	if current_shake_tween and current_shake_tween.is_valid():
		current_shake_tween.kill()
	if hand_move_tween and hand_move_tween.is_valid():
		hand_move_tween.kill()
		
func _on_hand_hide() -> void:
	if not merchant_hand:
		return
	if hand_hide_timer:
		hand_hide_timer.start()

func _on_hand_hide_timeout() -> void:
	if not merchant_hand:
		return
	# 停止抖动
	_stop_shake()
	# 复位到初始位置
	var initial_pos = Vector2(234, -54)
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
#	平移时长
	tween.tween_property(merchant_hand, "position", initial_pos, 2)

# 缓慢的随机抖动：使用 Tween 平滑移动到新位置，范围控制在 ±1.5 像素内
func _apply_hand_shake() -> void:
	if not merchant_hand or base_hand_pos == Vector2.ZERO:
		return

	# 随机偏移量，幅度较小
	var offset = Vector2(randf_range(-1.5, 1.5), randf_range(-1.5, 1.5))
	var target_pos = base_hand_pos + offset

	# 停止之前的抖动 tween，开始新的平滑移动
	if current_shake_tween and current_shake_tween.is_valid():
		current_shake_tween.kill()
	current_shake_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	current_shake_tween.tween_property(merchant_hand, "global_position", target_pos, 0.12)
