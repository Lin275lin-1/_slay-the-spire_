class_name MainSkillUI
extends Panel

@onready var portrait_cast: Panel = $PortraitCast
@onready var charge_label: RichTextLabel = $ChargeLabel
@onready var portrait: TextureRect = $PortraitCast/Portrait

var skill: MainSkill
var targets: Array[Node] = []
var targeting := false
var can_use := false

@export var player: Player

var tween: Tween

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)
	Events.skill_played.connect(_on_skill_played)
	

# 这两个信号是连接到资源上的，由于skill资源在一局游戏中不会销毁，需要手动取消连接，其实也可以不取消，这两个信号在其他场景不会触发
func _exit_tree() -> void:
	Events.enemy_died.disconnect(skill.gain_charge_over_kill)
	Events.player_turn_started.disconnect(skill.gain_charge_over_turn)

func set_skill(value: MainSkill):
	skill = value
	skill.skill_stats_changed.connect(update_skill)
	Events.enemy_died.connect(skill.gain_charge_over_kill)
	Events.player_turn_started.connect(skill.gain_charge_over_turn)
	portrait.texture = skill.portrait
	update_skill()

func update_skill():

	var factor := float(skill.current_charge) / skill.charge_cost
	#var current_panel_style_box: StyleBoxFlat
	if factor >= 1:
		charge_label.text = "[color=gold]{0}[/color]/{1}".format([skill.current_charge, skill.charge_cost])
		#current_panel_style_box = get_theme_stylebox("panel") as StyleBoxFlat
		#current_panel_style_box.bg_color = Color.from_hsv(60, 100 * factor, 100)
	else:
		charge_label.text = "{0}/{1}".format([skill.current_charge, skill.charge_cost])
		#current_panel_style_box = get_theme_stylebox("panel") as StyleBoxFlat
		#current_panel_style_box.bg_color = Color.from_hsv(60, 0, 100 * factor)
		
	#print(current_panel_style_box.bg_color)
	#add_theme_stylebox_override("panel", current_panel_style_box)
	can_use = skill.available()
	
func play() -> void:
	can_use = false
	Events.before_skill_played.emit(skill)
	skill.play(get_tree().get_first_node_in_group("ui_player"), targets)
	_on_mouse_exited()

func _on_mouse_entered() -> void:
	#if can_use:
		#if tween:
			#tween.kill()
		#tween = create_tween()
		#tween.set_parallel(true)
		#tween.tween_property(self, "position", original_position + Vector2(0, -7), 0.2)
		#tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)
		#tween.chain().tween_property(self, "position", original_position, 0.2)
	Events.tooltip_show_request.emit(self,  _show_keyword_tooltip)

func _on_mouse_exited() -> void:
	#if can_use:
		#if tween:
			#tween.kill()
		#tween = create_tween()
		#tween.set_parallel(true)
		#tween.tween_property(self, "scale", Vector2.ONE, 0.2)
		#tween.tween_property(self, "position", original_position, 0.2)
	Events.tooltip_hide_request.emit()
	
func _on_gui_input(event: InputEvent) -> void:
	if not can_use:
		return
	if event.is_action_pressed("left_mouse"):
		if skill == null:
			return
		if skill.target == Skill.Target.SELF:
			targets = get_tree().get_nodes_in_group("ui_player")
			play()
		elif skill.target == Skill.Target.ALL_ENEMIES:
			targets = get_tree().get_nodes_in_group("ui_enemies")
			play()
		else:
			if targeting:
				_end_aiming()
			else:
				_start_aiming()

func _input(event: InputEvent) -> void:
	if not targeting:
		return	
	if event.is_action_pressed("right_mouse"):
		_end_aiming()
	elif event.is_action_pressed("left_mouse"):
		get_viewport().set_input_as_handled()
		_end_aiming()
		if targets.is_empty():
			return
		play()

func _start_aiming() -> void:
	targets.clear()
	targeting = true
	Events.skill_aim_started.emit(self)

func _end_aiming() -> void:
	targeting = false
	Events.skill_aim_ended.emit(self)

func _show_keyword_tooltip() -> void:
	if skill:
		KeywordTooltip.add_keyword(skill.id, skill.get_description(player, null))
		KeywordTooltip.keyword_tooltip.global_position = global_position + Vector2(size.x / 2 * 1.4, 0)
		KeywordTooltip.show()

func _on_skill_played(_skill: Skill):
	skill.current_charge -= skill.charge_cost
	can_use = skill.available()
	
