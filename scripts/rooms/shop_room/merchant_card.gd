extends Control
class_name MerchantCard

const CARD_MENU_UI_SCENE = preload("res://scenes/ui/card_menu_ui.tscn")

signal card_clicked(card: Card)

#商人手部悬停
signal hand_hover_requested(card_node: Node)
signal hand_hide_requested()


@export var card_data: Card : set = _set_card_data

var card_ui_instance: CardMenuUI
var card_holder: Control
var hover_tween: Tween

func _ready():
	card_holder = get_node_or_null("CardHolder") as Control
	if not card_holder:
		print("错误：未找到 CardHolder")
		return
	if card_data:
		_refresh_display()

func _set_card_data(new_data: Card) -> void:
	if card_data == new_data:
		return
	card_data = new_data
	if is_inside_tree():
		_refresh_display()

func _refresh_display() -> void:
	if not card_data or not card_holder:
		return

	if not card_ui_instance:
		card_ui_instance = CARD_MENU_UI_SCENE.instantiate()
		card_holder.add_child(card_ui_instance)

		# 布局充满 CardHolder
		card_ui_instance.layout_mode = 1
		card_ui_instance.anchors_preset = Control.PRESET_FULL_RECT
		card_ui_instance.offset_left = 0
		card_ui_instance.offset_top = 0
		card_ui_instance.offset_right = 0
		card_ui_instance.offset_bottom = 0
		card_ui_instance.scale = Vector2(1.3, 1.3)

		# 覆盖悬停动画，断开原有信号
		_disconnect_card_ui_hover_signals()
		card_ui_instance.mouse_entered.connect(_on_custom_mouse_entered)
		card_ui_instance.mouse_exited.connect(_on_custom_mouse_exited)

		# 转发点击信号（供外部购买使用）
		if not card_ui_instance.inspect_card_requested.is_connected(_on_card_clicked):
			card_ui_instance.inspect_card_requested.connect(_on_card_clicked)

	card_ui_instance.card = card_data

func _disconnect_card_ui_hover_signals() -> void:
	for sig in ["mouse_entered", "mouse_exited"]:
		if card_ui_instance.has_signal(sig):
			for conn in card_ui_instance.get_signal_connection_list(sig):
				card_ui_instance.disconnect(sig, conn.callable)

func _on_custom_mouse_entered() -> void:
	if hover_tween and hover_tween.is_valid():
		hover_tween.kill()
	hover_tween = create_tween().set_trans(Tween.TRANS_SPRING)
	hover_tween.tween_property(card_ui_instance, "scale", Vector2(1.4, 1.4), 0.15)

	# 显示关键词 Tooltip（自定义位置与内容）
	_show_keyword_tooltip()
	
	hand_hover_requested.emit(self)

func _on_custom_mouse_exited() -> void:
	if hover_tween and hover_tween.is_valid():
		hover_tween.kill()
	hover_tween = create_tween().set_trans(Tween.TRANS_SPRING)
	hover_tween.tween_property(card_ui_instance, "scale", Vector2(1.3, 1.3), 0.15)

	# 隐藏关键词 Tooltip
	_hide_keyword_tooltip()
	
	hand_hide_requested.emit()

func _show_keyword_tooltip() -> void:
	if not card_data:
		return
	var desc = card_data.get_default_description()
	var keywords = KeywordTooltip.extract_keyword(desc)
	if keywords.is_empty():
		return

	# 清空旧内容
	if KeywordTooltip.has_method("clear"):
		KeywordTooltip.clear()
	else:
		# 如果 KeywordTooltip 没有 clear 方法，手动隐藏并重置内部列表（根据实际 API 调整）
		if KeywordTooltip.keyword_tooltip:
			KeywordTooltip.keyword_tooltip.hide()
		# 假设内部有 _keywords 数组，尝试置空（若不可访问则跳过）
		if KeywordTooltip.has_method("reset"):
			KeywordTooltip.reset()

	# 添加新关键词
	for keyword in keywords:
		var keyword_name = BuffLibrary.get_keyword_name(keyword)
		var desc_text = BuffLibrary.get_keyword_description(keyword)
		KeywordTooltip.add_keyword(keyword_name, desc_text)

	# 计算显示位置：卡牌右侧（考虑当前缩放）
	var pos = card_ui_instance.global_position + Vector2(card_ui_instance.size.x * card_ui_instance.scale.x -80, 0)
	if KeywordTooltip.keyword_tooltip:
		KeywordTooltip.keyword_tooltip.global_position = pos
		KeywordTooltip.keyword_tooltip.show()

func _hide_keyword_tooltip() -> void:
	if KeywordTooltip.keyword_tooltip:
		KeywordTooltip.keyword_tooltip.hide()
	# 可选：清空内容
	if KeywordTooltip.has_method("clear"):
		KeywordTooltip.clear()

func _on_card_clicked(card: Card) -> void:
	card_clicked.emit(card)
