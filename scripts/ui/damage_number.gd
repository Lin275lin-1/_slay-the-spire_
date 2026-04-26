class_name DamageLabel
extends Label

func set_parabola(top_pos: Vector2, end_pos: Vector2, rise_duration: float, fall_duration: float):
	var tween := create_tween()
	tween.set_parallel(true)
	# 上抛
	self.modulate.a = 0.5
	tween.tween_property(self, "position", top_pos, rise_duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "modulate:a", 1.0, rise_duration)
	tween.tween_property(self, "scale", Vector2.ONE * 1.35, rise_duration)
	# 下抛
	tween.chain().tween_property(self, "position", end_pos, fall_duration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	#tween.tween_property(label, "modulate:a", 0.5, fall_duration)
	tween.tween_property(self, "scale", Vector2.ONE * 0.9, fall_duration)
	tween.tween_property(self, "rotation_degrees", 0, fall_duration)
	tween.finished.connect(
		queue_free
	)

func set_float(top_pos, float_duration: float) -> void:
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(self, "position", top_pos, float_duration)
	tween.tween_property(self, "scale", Vector2.ONE * 1.35, float_duration)
	tween.tween_property(self, "modulate:a", 0.0, float_duration)
	tween.finished.connect(self.queue_free)
