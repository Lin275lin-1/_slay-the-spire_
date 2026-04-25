extends Control

const RELIC_UI_SCENE = preload("res://scenes/relichandler/relic_ui.tscn")
const TREASURE_RELIC_PILE = preload("res://entities/Treasure/Treasure_relics.tres")

@export var gold_min := 50
@export var gold_max := 150

@onready var chest: Control = $Chest
@onready var line_2d: Line2D = $Chest/Line2D
@onready var hands_container: Control = $HandsContainer
@onready var label: Label = $HandsContainer/Label
@onready var color_rect: ColorRect = $ColorRect
@onready var proceed_button: Button = $Button
@onready var relic_display: Control = $HandsContainer/Control

var is_opened: bool = false


func _ready():

	line_2d.modulate.a = 0.0
	hands_container.visible = false
	label.modulate.a = 0.0


	chest.mouse_filter = Control.MOUSE_FILTER_STOP
	chest.mouse_entered.connect(_on_chest_mouse_entered)
	chest.mouse_exited.connect(_on_chest_mouse_exited)
	chest.gui_input.connect(_on_chest_gui_input)


	proceed_button.visible = false
	proceed_button.pressed.connect(_on_proceed_pressed)
	proceed_button.mouse_entered.connect(_on_button_entered)
	proceed_button.mouse_exited.connect(_on_button_exited)


func _on_chest_mouse_entered():
	if is_opened:
		return
	var tween = create_tween()
	tween.tween_property(line_2d, "modulate:a", 1.0, 0.3)


func _on_chest_mouse_exited():
	var tween = create_tween()
	tween.tween_property(line_2d, "modulate:a", 0.0, 0.0)


func _on_chest_gui_input(event: InputEvent):
	if is_opened:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_open_chest()


func _open_chest():
	is_opened = true


	hands_container.visible = true
	label.modulate.a = 1.0
	color_rect.color.a = 1.0


	if chest.get_global_rect().has_point(get_global_mouse_position()):
		var hide_tween = create_tween()
		hide_tween.tween_property(line_2d, "modulate:a", 0.0, 0.0)


	await get_tree().create_timer(1.0).timeout
	%GoldExplosion.emitting = true
	_give_reward()
	proceed_button.visible = true


func _give_reward():
	var run_node = _get_run_node()
	if run_node and run_node.stats:
		var gold_amount = randi_range(gold_min, gold_max)
		run_node.stats.gold += gold_amount
		print("获得金币：", gold_amount)

#待修改
	var relic_pile = TREASURE_RELIC_PILE
	if relic_pile and relic_pile.relics.size() > 0:
		var random_relic: Relic = relic_pile.relics.pick_random()
		if run_node:
			run_node.top_bar.relic_handler.add_relic(random_relic)
		_show_relic_visual(random_relic)


func _show_relic_visual(relic: Relic):
	for child in relic_display.get_children():
		child.queue_free()

	var relic_ui = RELIC_UI_SCENE.instantiate() as RelicUI
	relic_display.add_child(relic_ui)
	relic_ui.size = relic_display.size
	relic_ui.mouse_filter = Control.MOUSE_FILTER_STOP
	relic_ui.z_index = 2
	relic_ui.set_relic(relic)
	# 不连接任何点击信号，只保留悬停提示


func _on_proceed_pressed():
	Events.treasure_room_exited.emit()


func _on_button_entered():
	_create_scale_tween(proceed_button, Vector2(1.1, 1.1))


func _on_button_exited():
	_create_scale_tween(proceed_button, Vector2.ONE)


func _create_scale_tween(node: Control, target_scale: Vector2):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(node, "scale", target_scale, 0.15)


func _get_run_node() -> Node:
	var current = self
	while current:
		if current is Run:
			return current
		current = current.get_parent()
	return null
