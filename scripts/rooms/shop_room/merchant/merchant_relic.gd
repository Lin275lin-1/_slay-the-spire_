extends Control
class_name MerchantRelic

const RELIC_UI_SCENE = preload("res://scenes/relichandler/relic_ui.tscn")

signal relic_clicked(relic: Relic)
signal hand_hover_requested(card_node: Node)
signal hand_hide_requested()

@export var relic_data: Relic : set = _set_relic_data

var cost_label: Label
var relic_ui_instance: RelicUI
var relic_holder: Control
var run_stats: RunStats
var original_scale: Vector2


func _ready():
	relic_holder = get_node_or_null("RelicHolder") as Control
	cost_label = get_node_or_null("Cost/CostLabel") as Label
	if not relic_holder:
		print("错误：未找到 RelicHolder")
		return
	if relic_data:
		_refresh_display()
	original_scale = scale


func _set_relic_data(new_data: Relic) -> void:
	if relic_data == new_data:
		return
	relic_data = new_data
	if is_inside_tree():
		_refresh_display()


func _refresh_display() -> void:
	if not relic_data or not relic_holder:
		return

	if not relic_ui_instance:
		relic_ui_instance = RELIC_UI_SCENE.instantiate()
		relic_holder.add_child(relic_ui_instance)
		relic_ui_instance.layout_mode = 1
		relic_ui_instance.anchors_preset = Control.PRESET_FULL_RECT
		relic_ui_instance.offset_left = 0
		relic_ui_instance.offset_top = 0
		relic_ui_instance.offset_right = 0
		relic_ui_instance.offset_bottom = 0

		# ✅ 保留 RelicUI 自身的鼠标信号，我们额外连接，不断开！
		relic_ui_instance.mouse_entered.connect(_on_relic_ui_mouse_entered)
		relic_ui_instance.mouse_exited.connect(_on_relic_ui_mouse_exited)
		relic_ui_instance.gui_input.connect(_on_relic_ui_gui_input)

	relic_ui_instance.set_relic(relic_data)
	_update_shop_price_display()
	_update_cost_color()


func _on_relic_ui_mouse_entered() -> void:
	scale = original_scale * 1.2
	hand_hover_requested.emit(self)
	# 不再手动操作 Tooltip，RelicUI 自己会处理


func _on_relic_ui_mouse_exited() -> void:
	scale = original_scale
	hand_hide_requested.emit()


func _on_relic_ui_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		relic_clicked.emit(relic_data)
		accept_event()


func set_run_stats(stats: RunStats):
	run_stats = stats
	_update_shop_price_display()
	_update_cost_color()


func _update_shop_price_display():
	if not relic_data or not cost_label:
		return
	cost_label.text = str(relic_data.shop_price)


func _update_cost_color():
	if not relic_data or not cost_label or not run_stats:
		return
	var can_afford = run_stats.gold >= relic_data.shop_price
	var color: Color
	if relic_data.on_sale:
		color = Color.GREEN
	else:
		color = Color.RED if not can_afford else Color.WHITE
	cost_label.add_theme_color_override("font_color", color)


func update_affordability():
	_update_cost_color()
