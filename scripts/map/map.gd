class_name Map
extends Node2D

#//滚动速度加快
const SCROLL_SPEED := 250
const MAP_ROOM = preload("res://scenes/map/map_room.tscn")
const MAP_LINE = preload("res://scenes/map/map_line.tscn")


@onready var map_generator: MapGenerator = $MapGenerator
@onready var lines: Node2D = %Lines
@onready var rooms: Node2D = %Rooms
@onready var visuals:Node2D = $Visuals
@onready var camera_2d:Camera2D = $Camera2D
@onready var legend: Legend = $Legend_background/Legend
@onready var legendAll: CanvasLayer = $Legend_background

@export var scroll_enabled: bool = true   # 滚动是否可用

#var map_data: Array[Array]
#var floors_climbed: int
@export var last_room: Room
@export var camera_edge_y: float

@export var room_to_lines: Dictionary = {} 

@export var run_stats: RunStats   # 外部状态

@export var old_camera_2d_position_y: float

# 预加载的商店场景资源
@export var shop_scene_resource: PackedScene = null

func _ready() -> void:
	camera_edge_y = MapGenerator.Y_DIST * (MapGenerator.FLOORS -1)
	
	legend.highlight_requested.connect(_on_legend_highlight_requested)
	legend.highlight_cleared.connect(_on_legend_highlight_cleared)
	
	_preload_shop_scene()
	#先执行 map的_ready()	方法
	#if run_stats.map_data == null:
		#generate_new_map()
	#unlock_floor(run_stats.floors_climbed)
	
	#await get_tree().process_frame  # 等待一帧确保视口尺寸已确定
	#var viewport_size = get_viewport().get_visible_rect().size
	#var design_size = Vector2(1000, 550)
	#var scale_factor = viewport_size / design_size
	## 取最小缩放因子以保持宽高比（与 keep aspect 类似）
	#var zoom_factor = min(scale_factor.x, scale_factor.y)
	#camera_2d.zoom = Vector2(zoom_factor, zoom_factor)
	
func _preload_shop_scene() -> void:
	# 如果已经加载过则跳过
	if shop_scene_resource != null:
		return
	# 使用 ResourceLoader 异步加载，不阻塞当前帧
	ResourceLoader.load_threaded_request("res://scenes/rooms/shop_room/shop_room.tscn")

# 获取已加载的商店场景资源（如果尚未完成则等待）
func get_shop_scene() -> PackedScene:
	if shop_scene_resource:
		return shop_scene_resource
	
	var path = "res://scenes/rooms/shop_room/shop_room.tscn"
	var status = ResourceLoader.load_threaded_get_status(path)
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		shop_scene_resource = ResourceLoader.load_threaded_get(path)
		return shop_scene_resource
	elif status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		# 如果还在加载中，可以等待或返回 null
		return null
	else:
		# 加载失败或未请求，同步加载作为后备
		shop_scene_resource = load(path)
		return shop_scene_resource
	
func init(stats:RunStats) -> void:
	run_stats = stats
	if run_stats.map_data.is_empty():
		generate_new_map()
	else:
		create_map()
	unlock_floor(run_stats.floors_climbed)


func _input(event:InputEvent) -> void:
	#print("Map._input received: ", event, " scroll_enabled: ", scroll_enabled)
	if not scroll_enabled:
		return                     # 禁用滚动时直接返回
	if event.is_action_pressed("scroll_up"):
		camera_2d.position.y = max(camera_2d.position.y - SCROLL_SPEED, -camera_edge_y)
	elif event.is_action_pressed("scroll_down"):
		camera_2d.position.y = min(camera_2d.position.y + SCROLL_SPEED, 0)
		
func generate_new_map() -> void:
	run_stats.floors_climbed =0
	run_stats.map_data = map_generator.generate_map()
	create_map()
	
func load_map(stats:RunStats,last_room_climbed:Room)->void:
	run_stats = stats
	last_room=last_room_climbed
	if run_stats.map_data.is_empty():
		generate_new_map()
	else:
		create_map()
	if run_stats.floors_climbed>0:
		unlock_next_rooms()
	else:
		unlock_floor()
	
func create_map() -> void:
	for current_floor: Array in run_stats.map_data:
		for room: Room in current_floor:
			if room.next_rooms.size() >0:
				_spawn_room(room)
				
	# Boss room has no next room but we need to spawn it
	var middle := floori(MapGenerator.MAP_WIDTH * 0.5)
	
	_spawn_room(run_stats.map_data[MapGenerator.FLOORS-1][middle])
	var map_width_pixels := MapGenerator.X_DIST * (MapGenerator.MAP_WIDTH -1)
	
	visuals.position.x = (get_viewport_rect().size.x - map_width_pixels) / 2
	visuals.position.y = get_viewport_rect().size.y / 2
	
	
			
func unlock_floor(which_floor:int = run_stats.floors_climbed) -> void:
	for map_room:MapRoom in rooms.get_children():
		if map_room.room.row == which_floor:
			map_room.available = true
			
func unlock_next_rooms() -> void:
	for map_room: MapRoom in rooms.get_children():
		if last_room.next_rooms.has(map_room.room):
			map_room.available = true
			
			
			
func show_map() -> void:
	show()
	camera_2d.enabled =true
		
func hide_map() -> void:
	hide()
	#camera_2d.enabled = false
	
func _spawn_room(room: Room) -> void:
	var new_map_room := MAP_ROOM.instantiate() as MapRoom
	rooms.add_child(new_map_room)   # 先加入场景树，让 @onready 变量完成初始化
	
	# 现在可以安全访问 Select_Circle 了
	if room.type == Room.Type.CAMPFIRE or room.type == Room.Type.SHOP:
		new_map_room.scale = Vector2(1.4, 1.4)
		new_map_room.Select_Circle.scale = Vector2(1.0, 1.0 )
	else:
		new_map_room.scale = Vector2(1.0005, 1.0005)
		new_map_room.Select_Circle.scale = Vector2(1.3,1.3)
	new_map_room.room = room
	new_map_room.selected.connect(_on_map_room_selected)
	_connect_lines(room)
	
	if room.selected and room.row < run_stats.floors_climbed:
		if room.type != Room.Type.ANCIENT and room.type != Room.Type.BOSS:
			new_map_room.show_selected()
		
	new_map_room.original_scale = new_map_room.scale
		
func _connect_lines(room: Room) -> void:
	if room.next_rooms.is_empty():
		return
	for next:Room in room.next_rooms:
		var new_map_line := MAP_LINE.instantiate() as Line2D
		new_map_line.add_point(room.position)
		new_map_line.add_point(next.position)
		# 设置初始透明度（ 0.2 ）
		new_map_line.modulate = Color(1, 1, 1, 0.1)
		lines.add_child(new_map_line)
		
func _on_map_room_selected(room: Room) -> void:
	# 立即发射信号，让场景切换最先开始
	Events.map_room_selected.emit(room)
	
	# 将本函数中原有的所有 UI 更新逻辑延迟到下一帧执行
	call_deferred("_apply_map_ui_updates", room)

func _apply_map_ui_updates(room: Room) -> void:
	for map_room: MapRoom in rooms.get_children():
		if map_room.room.row == room.row:
			map_room.available = false

	if last_room != null:
		update_line_opacity_between(last_room, room, 1.0)
	last_room = room

	old_camera_2d_position_y = camera_2d.position.y
	camera_2d.position.y = 0
	scroll_enabled = false
	hide()
	legendAll.hide()
	
func complete_current_room() -> void:
	if last_room == null:
		return
	var new_floor = last_room.row + 1
	run_stats.set_floor(new_floor)   # 假设 RunStats 中有 set_floor 方法发射信号
	unlock_next_rooms()
	
	#地图和legend显现,可以滚动
	show()
	camera_2d.position.y = old_camera_2d_position_y
	legendAll.show()
	scroll_enabled = true
	# 更新 floors_climbed：当前房间的下一层索引 = last_room.row + 1
	# 解锁新楼层（根据新 floors_climbed 解锁）
	#unlock_floor(run_stats.floors_climbed)
	# 可选：如果只想解锁相连的房间，可以使用 unlock_next_rooms()
	# 但 unlock_next_rooms 依赖 last_room，直接调用即可
	
func _on_legend_highlight_requested(type: int):
	#print("收到高亮请求，类型: ", type)
	for map_room in rooms.get_children():
		if map_room.room.type == type:
			map_room.set_highlight(true)

func _on_legend_highlight_cleared():
	for map_room in rooms.get_children():
		map_room.set_highlight(false)


func update_line_opacity_between(room_a: Room, room_b: Room, opacity: float) -> void:
	for line in lines.get_children():
		var points = line.points
		if points.size() == 2:
			var p1 = points[0]
			var p2 = points[1]
			if (p1.distance_to(room_a.position) < 1.0 and p2.distance_to(room_b.position) < 1.0) or \
			   (p1.distance_to(room_b.position) < 1.0 and p2.distance_to(room_a.position) < 1.0):
				line.modulate.a = opacity
				break   # 找到后退出循环
