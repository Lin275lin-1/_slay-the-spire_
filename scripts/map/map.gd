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

var scroll_enabled: bool = true   # 滚动是否可用

#var map_data: Array[Array]
#var floors_climbed: int
var last_room: Room
var camera_edge_y: float

var room_to_lines: Dictionary = {} 

var run_stats: RunStats   # 外部状态

var old_camera_2d_position_y: float

func _ready() -> void:
	camera_edge_y = MapGenerator.Y_DIST * (MapGenerator.FLOORS -1)
	
	legend.highlight_requested.connect(_on_legend_highlight_requested)
	legend.highlight_cleared.connect(_on_legend_highlight_cleared)
	
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
	
func create_map() -> void:
	
	
	
	for current_floor: Array in run_stats.map_data:
		for room: Room in current_floor:
			if room.next_rooms.size() >0:
				_spawn_room(room)
				
	# Boss room has no next room but we need to spawn it
	var middle := floori(MapGenerator.MAP_WIDTH * 0.5)
	
	_spawn_room(run_stats.map_data[MapGenerator.FLOORS-1][middle])
	var map_width_pixels := MapGenerator.X_DIST * (MapGenerator.MAP_WIDTH -1)
	var map_width_pixeLs := MapGenerator.X_DIST * (MapGenerator.MAP_WIDTH -1)
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
	rooms.add_child(new_map_room)
	new_map_room.room =room
	new_map_room.selected.connect(_on_map_room_selected)
	_connect_lines(room)
	
	if room.selected and room.row < run_stats.floors_climbed:
		new_map_room.show_selected()
		
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
		
func _on_map_room_selected(room:Room) -> void:
	for map_room:MapRoom in rooms.get_children():
		if map_room.room.row == room.row:
			map_room.available = false
	
			
	if last_room != null:
		update_line_opacity_between(last_room, room, 1.0)
	last_room = room
	#run_stats.floors_climbed += 1
	#update_line_opacity(room, 1.0)
	#test
	Events.map_room_selected.emit(room)
	
	#camera不可滚动,回到地图底部且所有背景消失
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
