class_name BuffTextureRect
extends TextureRect

func fade_out() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 2.0)
	tween.tween_property(self, "self_modulate:a", 0.1, 2.0)
	tween.finished.connect(queue_free)
