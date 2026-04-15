class_name Creature
extends Area2D

@warning_ignore_start("unused_signal")
signal before_turn_started(creature: Creature)
signal after_turn_started(creature: Creature)
signal turn_ended(creature: Creature)
signal before_take_damage(context: Context)
signal after_take_damage(context: Context)
signal before_lose_health(context: Context)
signal before_attack(context: Context)
signal before_gain_block(context: Context)
signal before_apply_buff(context: Context)
signal after_apply_buff(context: Context)
signal before_applied_buff(context: Context)
signal after_applied_buff(context: Context)
signal buff_changed()
@warning_ignore_restore("unused_signal")
# offset: 根据贴图大小调整各个组件

const BUFF_UI = preload("res://scenes/rooms/combat_room/combat_ui/buff_ui.tscn")

@onready var buff_container: GridContainer = $BuffContainer
@onready var buff_manager: BuffManager = $BuffManager
@onready var reticles: Node2D = $Reticles
@onready var health_bar: HealthBar = $HealthBar
@onready var speech_bubble: SpeechBubble = $SpeechBubble
@onready var name_label: Label = %NameLabel
@onready var name_plate: Control = $NamePlate
@onready var name_tween: Tween
@onready var damage_number_spawner: DamageNumberSpawner = $DamageNumberSpawner


var spine_anim_state: SpineAnimationState

func speech(_text: String, _time: float = 2.5) -> void:
	pass

func attack(context: Context) -> int:
	var damage_context = DamageContext.new(self, context.target, context.amount, context.modifiers)
	before_attack.emit(damage_context)
	return context.target.take_damage(damage_context)
	
func gain_block(_context: Context) -> void:
	pass

func apply_buff(buff_context: ApplyBuffContext) -> int:
	before_apply_buff.emit(buff_context)
	var ret = buff_context.target.add_buff(buff_context)
	after_apply_buff.emit(buff_context)
	return ret

func has_buff(name_: String) -> bool:
	for child: Buff in buff_manager.get_children():
		if child.buff_name == name_:
			return true
	return false
	
func add_buff(buff_context: ApplyBuffContext) -> int:
	before_applied_buff.emit(buff_context)
	if not buff_context.buff_node:
		return 0
	#buff_context.buff_node.stacks = buff_context.amount	
	var buff_stacks = buff_manager.add_buff(buff_context)
	if buff_stacks == 0:
		var buff_ui :BuffUI = BUFF_UI.instantiate()
		buff_ui.buff = buff_context.buff_node
		buff_ui.agent = self
		buff_container.add_child(buff_ui)
	damage_number_spawner.spawn_buff_label(buff_context.buff_node.buff_name, buff_context.buff_node.type == Buff.Type.BUFF)
	damage_number_spawner.spawn_buff_icon(buff_context.buff_node.icon)
	after_applied_buff.emit(buff_context)
	return buff_stacks + buff_context.amount

func get_buff(buff_name: String) -> Buff:
	for buff: Buff in buff_manager.get_children():
		if buff.buff_name == buff_name:
			return buff
	return null

func get_modifiers_by_type(type: Enums.NumericType, affect: Buff.AFFECT) -> Array:
	var ret := []
	for child: Buff in buff_manager.get_children():
		if child.affect == affect or child.affect == Buff.AFFECT.ALL:
			ret += child.get_modifiers_by_type(type)
	return ret

func start_turn() -> void:
	before_turn_started.emit(self)
	after_turn_started.emit(self)

func end_turn() -> void:
	turn_ended.emit(self)
	
func lose_health(_context: Context) -> int:
	return 0
	
func take_damage(_context: Context) -> int:
	return 0

func die() -> void:
	pass

func set_recticles(positions: Array[Vector2], reticle_scale: Vector2) -> void:
	for i in range(4):
		var reticle: Node2D = reticles.get_child(i)
		reticle.position = positions[i]
		reticle.scale = reticle_scale
	
func show_name() -> void:
	if name_tween:
		name_tween.kill()
	name_tween = create_tween()
	name_tween.tween_property(name_plate, "modulate:a", 1.0, 0.3)

func hide_name() -> void:
	if name_tween:
		name_tween.kill()
	name_tween = create_tween()
	name_tween.tween_property(name_plate, "modulate:a", 0.0, 0.3)
