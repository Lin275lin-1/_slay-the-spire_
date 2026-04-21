class_name MapRoom
extends Area2D


signal selected(room:Room)

const ICONS := {
	Room.Type.NOT_ASSIGNED:[null,Vector2.ONE],
	Room.Type.MONSTER:[preload("res://images/atlases/ui_atlas.sprites/map/icons/map_monster.tres"),Vector2.ONE],
	Room.Type.TREASURE:[preload("res://images/atlases/ui_atlas.sprites/map/icons/map_chest.tres"),Vector2.ONE],
	Room.Type.CAMPFIRE:[preload("res://images/atlases/ui_atlas.sprites/map/icons/map_rest.tres"), Vector2(0.6,0.6)],
	Room.Type.SHOP:[preload("res://images/atlases/ui_atlas.sprites/map/icons/map_shop.tres"), Vector2(0.6,0.6)],
	Room.Type.BOSS:[preload("res://images/map/placeholder/vantom_boss_icon.png"),Vector2(1.25,1.25)],
	Room.Type.ELITE:   [preload("res://images/atlases/ui_atlas.sprites/map/icons/map_elite.tres"), Vector2.ONE],  
	Room.Type.UNKNOWN: [preload("res://images/atlases/ui_atlas.sprites/map/icons/map_unknown.tres"), Vector2.ONE],   
}

@onready var highlight_sprite: Sprite2D = $Visuals/highlight
@onready var sprite_2d:Sprite2D = $Visuals/Sprite2D
@onready var Select_Circle:Node2D = $Select_Circle
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var original_modulate: Color
var original_scale: Vector2
var target_alpha := 0.6   # 存储房间非(被legend)时的目标透明度

func _ready():
	original_modulate = modulate
	original_scale = scale
	
	sprite_2d.modulate.a = 0.6
#debug
#func _ready() -> void:
	#var test_room := Room.new()
	#test_room.type = Room.Type.CAMPFIRE
	#test_room.position = Vector2(100, 100)
	#room = test_room
	#await get_tree().create_timer(3).timeout
	##connect("input_event", Callable(self, "_on_input_event"))
	#available = true	


var available := false : set = set_available
var room : Room : set = set_room

func set_available(new_value:bool) -> void:
	available = new_value
	if available:
		animation_player.play("highlight")
		if not room.selected:
			target_alpha = 0.6
			sprite_2d.modulate.a = target_alpha
	elif not room.selected:
		animation_player.play("RESET")
		target_alpha = 0.6
		sprite_2d.modulate.a = target_alpha
		
			 
func set_room(new_data: Room) -> void:
	room = new_data
	position = room.position
	Select_Circle.rotation_degrees = randi_range(0,360)
	
#	图片选择 以及 规模设置
	sprite_2d.texture = ICONS[room.type][0]
	sprite_2d.scale = ICONS[room.type][1]

#func show_selected() -> void:
	#Select_Circle.modulate = Color.BLACK
	#sprite_2d.modulate.a = 1.0           # 选中后完全不透明	

func _on_input_event(_viewport:Node, event:InputEvent, _shape_idx:int) -> void:
	#print("事件触发, available=", available, ", 动作=", event.as_text())
	if not available or not event.is_action_pressed("left_mouse"):
		return
	room.selected = true
	animation_player.speed_scale = 2.0
	animation_player.play("select")
	#animation_player.speed_scale = 1.0
	target_alpha = 1.0
	sprite_2d.modulate.a = target_alpha        # 选中后完全不透明	
	#print("clicked")
	
	
# Called by the AnimationPLayer when the
#"select" animation finishes.
func _on_map_room_selected() -> void:
	#print("动画结束，发射信号")
	selected.emit(room)


func set_highlight(highlight: bool):
	if highlight:
		# 高亮时：图标变为完全不透明
		sprite_2d.modulate.a = 1.0
		# 以下为原有高亮效果（颜色、缩放等），可根据需要保留或注释
		modulate = Color(1, 1, 0.5, 1.0)  
		if room.type == Room.Type.UNKNOWN:
			highlight_sprite.modulate.a = 1.0
		if room.type == Room.Type.ELITE and room.type == Room.Type.MONSTER:
			scale = original_scale * 2.6
		else:
			scale = original_scale * 1.2
	else:
		# 退出高亮：恢复房间应有的透明度
		sprite_2d.modulate.a = target_alpha
		# 恢复颜色和缩放
		modulate = Color.WHITE
		scale = original_scale
		highlight_sprite.modulate.a = 0.0



	
