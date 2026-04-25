class_name MapRoom
extends Area2D

signal selected(room: Room)

const ICONS := {
	Room.Type.NOT_ASSIGNED: [null, Vector2.ONE],
	Room.Type.MONSTER: [preload("res://images/atlases/ui_atlas.sprites/map/icons/map_monster.tres"), Vector2.ONE],
	Room.Type.TREASURE: [preload("res://images/atlases/ui_atlas.sprites/map/icons/map_chest.tres"), Vector2.ONE],
	Room.Type.CAMPFIRE: [preload("res://images/atlases/ui_atlas.sprites/map/icons/map_rest.tres"), Vector2(0.6, 0.6)],
	Room.Type.SHOP: [preload("res://images/atlases/ui_atlas.sprites/map/icons/map_shop.tres"), Vector2(0.6, 0.6)],
	# todo vantom.tres
	Room.Type.BOSS: [preload("res://images/map/placeholder/vantom_boss_icon.png"), Vector2(1.25, 1.25)],
	Room.Type.ELITE: [preload("res://images/atlases/ui_atlas.sprites/map/icons/map_elite.tres"), Vector2.ONE],
	Room.Type.UNKNOWN: [preload("res://images/atlases/ui_atlas.sprites/map/icons/map_unknown.tres"), Vector2.ONE],
	Room.Type.ANCIENT: [preload("res://images/atlases/ui_atlas.sprites/map/ancients/ancient_node_neow.tres"), Vector2.ONE]
}

@onready var highlight_sprite: Sprite2D = $Visuals/highlight
@onready var sprite_2d: Sprite2D = $Visuals/Sprite2D
@onready var Select_Circle: Node2D = $Select_Circle
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var original_modulate: Color
var original_scale: Vector2
var target_alpha := 0.6

func _ready():
	original_modulate = modulate
	original_scale = scale

var available := false : set = set_available
var room : Room : set = set_room

func set_available(new_value: bool) -> void:
	available = new_value
	if available:
		# 古代房不播放 highlight 动画
		if room.type != Room.Type.ANCIENT:
			animation_player.play("highlight")
		if not room.selected:
			sprite_2d.modulate.a = target_alpha
	elif not room.selected:
		if room.type != Room.Type.ANCIENT:
			animation_player.play("RESET")
		sprite_2d.modulate.a = target_alpha

func set_room(new_data: Room) -> void:
	room = new_data
	position = room.position
	Select_Circle.rotation_degrees = randi_range(0, 360)

	sprite_2d.texture = ICONS[room.type][0]
	sprite_2d.scale = ICONS[room.type][1]
	original_scale = scale

<<<<<<< HEAD
	# 古代房始终保持完全不透明
	if room.type == Room.Type.ANCIENT:
		target_alpha = 1.0
		sprite_2d.modulate.a = 1.0
	else:
		target_alpha = 0.6
		sprite_2d.modulate.a = target_alpha
=======
func show_selected() -> void:
	Select_Circle.modulate = Color.BLACK
	sprite_2d.modulate.a = 1.0           # 选中后完全不透明	
>>>>>>> 9a7f11eee5fb6efad8567b78814b06ef8a0a9af3

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not available or not event.is_action_pressed("left_mouse"):
		return

	room.selected = true
	target_alpha = 1.0
	sprite_2d.modulate.a = target_alpha

	# 古代房与 Boss 房：直接发射信号，不播放 select 动画
	if room.type == Room.Type.ANCIENT or room.type == Room.Type.BOSS:
		selected.emit(room)
	else:
		animation_player.speed_scale = 2.0
		animation_player.play("select")

# 正常房间的 select 动画结束后回调
func _on_map_room_selected() -> void:
	selected.emit(room)

func set_highlight(highlight: bool):
	# 古代房与 Boss 房不参与高亮
	if room.type == Room.Type.ANCIENT or room.type == Room.Type.BOSS:
		return

	if highlight:
		sprite_2d.modulate.a = 1.0
		modulate = Color(1, 1, 0.5, 1.0)
		if room.type == Room.Type.UNKNOWN:
			highlight_sprite.modulate.a = 1.0
		if room.type == Room.Type.ELITE or room.type == Room.Type.MONSTER:
			scale = original_scale * 1.5
		else:
			scale = original_scale * 1.2
	else:
		sprite_2d.modulate.a = target_alpha
		modulate = Color.WHITE
		scale = original_scale
		highlight_sprite.modulate.a = 0.0
