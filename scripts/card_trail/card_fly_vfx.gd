class_name CardFlyVFX
extends Node2D

var card: Control
var trail_path: String
var vfx: CardTrailVFX
var character_color: CharacterStats.COLOR = CharacterStats.COLOR.RED
var tween: Tween
var vfx_is_fading: bool
var start_pos: Vector2
var end_pos: Vector2
var control_point_offset: float
var duration: float
var speed: float
var accel: float
var arc_dir: float

func _init(card_: Control, end_: Vector2, character_color_: CharacterStats.COLOR) -> void:
	card = card_
	start_pos = card_.global_position
	end_pos = end_
	character_color = character_color_

func _ready() -> void:
	vfx = CardTrailVFX.create(card, character_color)
	if vfx:
		get_parent().add_child(vfx)
	control_point_offset = randf_range(100, 400)
	speed = randf_range(1.1, 1.25)
	accel = randf_range(2.0, 2.5)
	arc_dir = -500.0 if (end_pos.y < get_viewport_rect().size.y * 0.5) else (500.0 + control_point_offset)
	duration = randf_range(1, 1.75)
	card.tree_exited.connect(_on_card_exited_tree)
	play_anim()

func play_anim() -> void:
	var time: float = 0.0
	while time / duration <= 1.0:
		await get_tree().process_frame
		var num := get_process_delta_time()
		time += speed * num
		speed += accel * num
		var c: Vector2 = start_pos + (end_pos - start_pos) * 0.5
		c.y -= arc_dir
		var vector: Vector2 = bezier_curve(start_pos, end_pos, c, (time + 0.05) / duration)
		card.global_position = bezier_curve(start_pos, end_pos, c, time / duration)
		var num2 = (vector - card.global_position).angle() + PI / 2.0
		var parent: Node = card.get_parent()
		if parent is Control:
			num2 -= parent.rotation
		elif parent is Node2D:
			num2 -= parent.rotation
		card.rotation = lerp_angle(card.rotation, num2, time/duration)
		card.modulate = Color.WHITE.lerp(Color.BLACK, clamp(time * 3.0 / duration, 0, 1))
		card.scale = Vector2.ONE * lerp(1.0, 0.1, clamp(time * 3.0 / duration, 0, 1.0))
	card.global_position = end_pos
	time = 0.0
	while (time / duration <= 1.0):
		await get_tree().process_frame
		var num3: float = get_process_delta_time()
		time += speed * num3
		if (time / duration > 0.25 && !vfx_is_fading):
			if vfx:
				vfx.fade_out()
			vfx_is_fading = true
		card.scale = Vector2.ONE * max(lerp(0.1, -0.15, time / duration), 0)
	card.queue_free()
	
func bezier_curve(v0: Vector2, v1: Vector2, c0: Vector2, t: float) -> Vector2:
	return pow(1.0 - t, 2.0) * v0 + 2.0 * (1.0 - t) * t * c0 + pow(t, 2.0) * v1

func _on_card_exited_tree() -> void:
	vfx.queue_free()
	queue_free()
	
	
