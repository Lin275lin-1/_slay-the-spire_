class_name ShakeEffect
extends RichTextEffect

var bbcode := "shake"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var speed = char_fx.elapsed_time * 20.0
	var offset = Vector2(sin(speed * 2.0) * 1.5, cos(speed * 1.7) * 1.5)
	char_fx.offset = offset
	char_fx.color = char_fx.color  # 保持原色
	return true
