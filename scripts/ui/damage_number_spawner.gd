class_name DamageNumberSpawner
extends Node2D

@export var damage_number_label_settings: LabelSettings
@export var text_label_settings: LabelSettings
@export var blocked_hit_color: Color = Color("8fd3ff")
@export var buff_color: Color = Color(0.0, 0.631, 0.0, 1.0)
@export var debuff_color: Color = Color(0.808, 0.0, 0.0, 1.0)

const FLOAT_TIME := 3.5
const RISE_TIME := 1.0
const FALL_TIME := 2.0

var agent: Node

func spawn_buff_icon(buff_icon: Texture2D) -> void:
	var new_texture: TextureRect = TextureRect.new()
	new_texture.texture = buff_icon
	new_texture.pivot_offset = buff_icon.get_size() / 2
	new_texture.position = global_position - buff_icon.get_size() / 2
	new_texture.self_modulate.a = 0.5
	new_texture.scale = Vector2(0.5, 0.5)
	
	agent.call_deferred("add_child", new_texture)
	await new_texture.tree_entered
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(new_texture, "scale", Vector2(1.0, 1.0), 2.0)
	tween.tween_property(new_texture, "self_modulate:a", 0.1, 2.0)
	tween.finished.connect(new_texture.queue_free)
	
func spawn_buff_label(buff_name: String, is_buff: bool) -> void:
	var new_label: DamageLabel = DamageLabel.new()
	new_label.label_settings = text_label_settings.duplicate()
	new_label.text = buff_name
	# 确保伤害数字在最上层
	new_label.z_index = 1000
	new_label.pivot_offset_ratio = Vector2(0.5, 1.0)
	
	if is_buff:
		new_label.label_settings.font_color = buff_color
	else:
		new_label.label_settings.font_color = debuff_color
	
	agent.call_deferred("add_child", new_label)
	await new_label.resized
	#add_child(new_label)
	
	new_label.position = global_position + Vector2(-new_label.size.x / 2, new_label.size.y)
	var target_rise_pos: Vector2 = new_label.position + Vector2(0, -400)
	
	new_label.set_float(target_rise_pos, FLOAT_TIME)

func spawn_damage_label(number: int, blocked: bool = false) -> void:
	var new_label: DamageLabel = DamageLabel.new()
	
	# 确保伤害数字在最上层
	new_label.z_index = 1000
	new_label.pivot_offset_ratio = Vector2(0.5, 1.0)
	agent.call_deferred("add_child", new_label)
	await new_label.resized
	
	new_label.position = global_position + Vector2(-new_label.size.x / 2, new_label.size.y)
	new_label.position += Vector2(randf_range(-50.0, 50.0), 0)
	
	var target_rise_pos: Vector2 = new_label.position + Vector2(randf_range(-100.0, 100.0), randf_range(-400, -300))
	var target_fall_pos: Vector2 = Vector2(new_label.position.x - (new_label.position.x - target_rise_pos.x) * 3, 1080)
	if blocked:
		new_label.label_settings = text_label_settings.duplicate()
		new_label.label_settings.font_color = blocked_hit_color
		new_label.text = "格挡"
		new_label.set_float(target_rise_pos, FLOAT_TIME)
	else:
		new_label.text = str(number)
		new_label.label_settings = damage_number_label_settings
		new_label.set_parabola(target_rise_pos, target_fall_pos, RISE_TIME, FALL_TIME)
		
# 在damage_label中实现
#func set_parabola(label: Label, top_pos: Vector2, end_pos: Vector2, rise_duration: float, fall_duration: float):
	#var tween := create_tween()
	#tween.set_parallel(true)
	# 上抛
	#label.modulate.a = 0.5
	#tween.tween_property(label, "position", top_pos, rise_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	#tween.tween_property(label, "modulate:a", 1.0, rise_duration)
	#tween.tween_property(label, "scale", Vector2.ONE * 1.35, rise_duration)
	# 下抛
	#tween.chain().tween_property(label, "position", end_pos, fall_duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	#tween.tween_property(label, "modulate:a", 0.5, fall_duration)
	#tween.tween_property(label, "scale", Vector2.ONE * 0.9, fall_duration)
	#tween.finished.connect(
		#label.queue_free
	#)
#
#func set_float(label: Label, top_pos, float_duration: float) -> void:
	#var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	#tween.set_parallel(true)
	#tween.tween_property(label, "position", top_pos, float_duration)
	#tween.tween_property(label, "scale", Vector2.ONE * 1.35, float_duration)
	#tween.tween_property(label, "modulate:a", 0.0, float_duration)
	#tween.finished.connect(label.queue_free)
