class_name CardShuffleVFX
extends Control

var vfx: CardTrailVFX
var character_color: CharacterStats.COLOR = CharacterStats.COLOR.RED
var tween: Tween
var vfx_fading: bool = false
var start_pos: Vector2
var end_pos: Vector2
var control_point_offset: float
var duration: float
var speed: float
var accel: float
var arc_dir: float
var trail_path: String

func _init(start_pos_: Vector2, end_pos_: Vector2, character_color_: CharacterStats.COLOR) -> void:
	start_pos = start_pos_
	end_pos = end_pos_
	character_color = character_color_

func _ready() -> void:
	control_point_offset = randf_range(-300, 400)
	speed = randf_range(1.1, 1.25)
	accel = randf_range(2, 2.5)
	arc_dir = -500.0 if (end_pos.y < 540) else (500.0 + control_point_offset)
	duration = randf_range(1, 1.75)
	vfx = CardTrailVFX.create(self, character_color)
	if vfx:
		get_parent().add_child(vfx)
	var parent = get_parent()
	parent.move_child(self, parent.get_child_count() - 1)
	play_anim()

	
func play_anim() -> void:
	var time: float = 0.0
	while (time / duration <= 1.0):
		await get_tree().process_frame
		var num = get_process_delta_time()
		time += speed * num;
		speed += accel * num;
		var c = start_pos + (end_pos - start_pos) * 0.5
		c.y -= arc_dir
		global_position = bezier_curve(start_pos, end_pos, c, time / duration)
		var vector: Vector2 = bezier_curve(start_pos, end_pos, c, (time + 0.05) / duration)
		rotation = (vector - global_position).angle() + PI / 2.0
	global_position = end_pos
	time = 0.0
	while (time / duration <= 1.0):
		await get_tree().process_frame
		var num2 = get_process_delta_time()
		time += speed * num2
		if (time / duration > 0.25 && !vfx_fading):
			if vfx:
				vfx.fade_out()
		scale = Vector2.ONE * max(lerp(0.1, -0.1, time / duration), 0)
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.8)
	await tween.finished
	queue_free()
	
func bezier_curve(v0: Vector2, v1: Vector2, c0: Vector2, t: float) -> Vector2:
	return pow(1.0 - t, 2.0) * v0 + 2.0 * (1.0 - t) * t * c0 + pow(t, 2.0) * v1
