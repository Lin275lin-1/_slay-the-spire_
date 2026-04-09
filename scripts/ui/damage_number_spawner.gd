class_name DamageNumberSpawner
extends Node2D

@export var label_setttings: LabelSettings
@export var blocked_hit_color: Color = Color("8fd3ff")
@export var buff_color: Color = Color(0.0, 0.631, 0.0, 1.0)
@export var debuff_color: Color = Color(0.808, 0.0, 0.0, 1.0)

const TWEEN_LENGTH := 3.5

func spawn_buff_label(buff_name: String, is_buff: bool) -> void:
	var new_label: Label = Label.new()
	new_label.label_settings = label_setttings.duplicate()
	new_label.text = buff_name
	# 确保伤害数字在最上层
	new_label.z_index = 1000
	new_label.pivot_offset_ratio = Vector2(0.5, 1.0)
	
	if is_buff:
		new_label.label_settings.font_color = buff_color
	else:
		new_label.label_settings.font_color = debuff_color
	
	call_deferred("add_child", new_label)
	# 在label的text被赋值是就会触发resize信号
	await new_label.resized
	new_label.position = Vector2(-new_label.size.x / 2, new_label.size.y)
	
	var target_rise_pos: Vector2 = new_label.position + Vector2(0, -400)
	var label_tween: Tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	label_tween.set_parallel(true)
	label_tween.tween_property(new_label, "position", target_rise_pos, TWEEN_LENGTH)
	label_tween.tween_property(new_label, "scale", Vector2.ONE * 1.35, TWEEN_LENGTH)
	label_tween.tween_property(new_label, "modulate:a", 0.0, TWEEN_LENGTH)
	label_tween.finished.connect(new_label.queue_free)

func spawn_damage_label(number: int, blocked: bool = false) -> void:
	var new_label: Label = Label.new()
	new_label.label_settings = label_setttings.duplicate()
	# 确保伤害数字在最上层
	new_label.z_index = 1000
	new_label.pivot_offset_ratio = Vector2(0.5, 1.0)
	
	if blocked:
		new_label.label_settings.font_color = blocked_hit_color
		new_label.text = "格挡"
	else:
		new_label.text = str(number)
		
	call_deferred("add_child", new_label)
	# 在label的text被赋值是就会触发resize信号
	await new_label.resized
	new_label.position = Vector2(-new_label.size.x / 2, new_label.size.y)
	new_label.position += Vector2(randf_range(-50.0, 50.0), 0)
	
	var target_rise_pos: Vector2 = new_label.position + Vector2(randf_range(-50.0, 50.0), randf_range(-600, -400))
	var label_tween: Tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	label_tween.set_parallel(true)
	label_tween.tween_property(new_label, "position", target_rise_pos, TWEEN_LENGTH)
	label_tween.tween_property(new_label, "scale", Vector2.ONE * 1.35, TWEEN_LENGTH)
	label_tween.tween_property(new_label, "modulate:a", 0.0, TWEEN_LENGTH)
	label_tween.finished.connect(new_label.queue_free)
	
