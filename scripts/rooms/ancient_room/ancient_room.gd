extends Control

#const ANCIENT_RELIC_PILE = preload("res://entities/ancient/ancient_room_relic_pile.tres")
const RELIC_UI_SCENE = preload("res://scenes/relichandler/relic_ui.tscn")
const NEOW_ICON = preload("res://images/ui/run_history/neow.png")

@export var relic_spacing: int = 100
@export var tooltip_offset: Vector2 = Vector2(200, -140)

@onready var spine_sprite: SpineSprite = $SpineSprite
@onready var relic_container: Control = $Control
@onready var return_button: Button = $Button   

var relic_buttons: Array[Control] = []

# 对话相关
var dialogue_container: HBoxContainer
var neow_icon: TextureRect
var dialogue_label: RichTextLabel

# 台词库
const OPENING_LINES := [
	"啊...你醒了。选一件[shake freq=20]先古遗物[/shake]，然后继续你的旅程。",
	"又见面了，旅人。挑一件[shake freq=20]恩赐[/shake]吧。",
	"命运之轮再次转动...选择一件[shake freq=20]远古遗物[/shake]，它将与你同行。"
]

const AFTER_CHOICE_LINES := [
	"明智的选择。愿这份力量守护你。",
	"很好。它会陪伴你走过下一段路。",
	"一切早已注定。去吧，前方还有很长的路。"
]

func _ready() -> void:
	spine_sprite.get_animation_state().set_animation("idle_loop", true, 0)
	
	# 按钮初始隐藏，连接信号
	return_button.visible = false
	return_button.pressed.connect(_on_return_pressed)
	
	_create_dialogue_ui()
	_show_random_opening()
	_create_relic_options()
	return_button.mouse_entered.connect(_on_button_entered)
	return_button.mouse_exited.connect(_on_button_exited)

func _create_dialogue_ui() -> void:
	dialogue_container = HBoxContainer.new()
	dialogue_container.position = Vector2(700, 650)   # 指定位置
	dialogue_container.custom_minimum_size.x = 700    # 限制宽度，自动换行
	dialogue_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dialogue_container.z_index = 10
	add_child(dialogue_container)

	# Neow 头像
	neow_icon = TextureRect.new()
	neow_icon.texture = NEOW_ICON
	neow_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	neow_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	neow_icon.custom_minimum_size = Vector2(48, 48)
	dialogue_container.add_child(neow_icon)

	dialogue_label = RichTextLabel.new()
	dialogue_label.add_theme_font_size_override("normal_font_size", 24)  
	dialogue_label.bbcode_enabled = true
	dialogue_label.scroll_active = false
	dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialogue_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dialogue_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	dialogue_container.add_child(dialogue_label)

	var shake_effect = load("res://entities/ancient/neow_rich_text_effect.tres")
	if shake_effect:
		dialogue_label.custom_effects.append(shake_effect)

func _show_random_opening() -> void:
	dialogue_label.text = OPENING_LINES[randi() % OPENING_LINES.size()]

func _show_random_after_choice() -> void:
	dialogue_label.text = AFTER_CHOICE_LINES[randi() % AFTER_CHOICE_LINES.size()]

func _on_return_pressed() -> void:
	Events.ancient_exited.emit()

func _create_relic_options() -> void:
	var choices := _pick_random_relics(3)
	if choices.is_empty():
		return

	for child in relic_container.get_children():
		child.queue_free()
	relic_buttons.clear()

	var hbox = HBoxContainer.new()
	hbox.name = "RelicOptions"
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.custom_minimum_size = relic_container.size
	hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hbox.add_theme_constant_override("separation", relic_spacing)

	var empty_style = StyleBoxEmpty.new()
	hbox.add_theme_stylebox_override("panel", empty_style)

	relic_container.add_child(hbox)

	for relic in choices:
		var relic_ui = RELIC_UI_SCENE.instantiate() as RelicUI
		relic_ui.custom_minimum_size = Vector2(140, 140)
		relic_ui.mouse_filter = Control.MOUSE_FILTER_STOP
		relic_ui.set_relic(relic)

		# 断开自带 tooltip
		if relic_ui.mouse_entered.is_connected(relic_ui._on_mouse_entered):
			relic_ui.mouse_entered.disconnect(relic_ui._on_mouse_entered)
		if relic_ui.mouse_exited.is_connected(relic_ui._on_mouse_exited):
			relic_ui.mouse_exited.disconnect(relic_ui._on_mouse_exited)

		relic_ui.mouse_entered.connect(_on_relic_mouse_entered.bind(relic_ui, relic))
		relic_ui.mouse_exited.connect(_on_relic_mouse_exited)


		relic_ui.mouse_entered.connect(
			func(): create_tween().tween_property(relic_ui, "scale", Vector2(1.1, 1.1), 0.1)
		)
		relic_ui.mouse_exited.connect(
			func(): create_tween().tween_property(relic_ui, "scale", Vector2(1.0, 1.0), 0.1)
		)

		relic_ui.gui_input.connect(_on_relic_ui_input.bind(relic_ui, relic))

		hbox.add_child(relic_ui)
		relic_buttons.append(relic_ui)

func _pick_random_relics(amount: int) -> Array[Relic]:
	var color_mask = _get_character_color_mask()
	if color_mask == 0:
		return []

	# 获取该角色颜色的所有遗物
	var all_relics = ItemPool.get_relics_by_color(color_mask)
	
	# 过滤出古代遗物（假设 ANCIENT_RELIC 枚举值为 0b100000）
	#var ancient_relics = all_relics.filter(
		#func(r: Relic): return r.rarity & Relic.Rarity.ANCIENT_RELIC != 0
	#)
	all_relics.shuffle()

	var result: Array[Relic] = []
	for relic in all_relics:
		result.append(relic)
		if result.size() >= amount:
			break
	return result

func _on_relic_ui_input(event: InputEvent, relic_ui: Control, relic: Relic) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_select_relic(relic_ui, relic)

func _select_relic(relic_ui: Control, relic: Relic) -> void:
	for btn in relic_buttons:
		btn.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# 不要直接访问 stats，只发射信号，让 Run 去处理添加
	Events.ancient_relic_selected.emit(relic)

	for child in relic_container.get_children():
		child.queue_free()
	relic_buttons.clear()

	_show_random_after_choice()
	return_button.visible = true

func _on_relic_mouse_entered(relic_ui: Control, relic: Relic) -> void:
	KeywordTooltip.add_keyword(relic.relic_name, relic.description)
	KeywordTooltip.show()

func _on_relic_mouse_exited() -> void:
	KeywordTooltip.hide()

func _on_button_entered():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(return_button, "scale", Vector2(1.1, 1.1), 0.15)

func _on_button_exited():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(return_button, "scale", Vector2(1.0, 1.0), 0.15)


func _get_character_color_mask() -> int:
	var run_node = _get_run_node()
	if not run_node or not run_node.character:
		return 0
	var char_name = _get_character_name(run_node.character)
	match char_name:
		"ironclad": return Card.COLOR.RED
		"silent":   return Card.COLOR.GREEN
		# 后续角色扩展
		_: return 0

func _get_character_name(character) -> String:
	if not character:
		return ""
	print("先古房当前角色:",character.character_name)
	match character.character_name:
		"铁甲战士": return "ironclad"
		"静默猎手": return "silent"
		_: return ""
	
func _get_run_node():
	var current = self
	while current:
		if current is Run:
			return current
		current = current.get_parent()
	return null
