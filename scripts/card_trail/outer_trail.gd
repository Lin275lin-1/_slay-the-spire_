extends Line2D


var agent: Node2D
var point_duration := 0.8
var point_age :Array[float] = []
var min_spawn_dist := 12.0
var max_spawn_dist := 48.0
var last_point_position: Vector2

func _ready() -> void:
	agent = get_parent()
	self.visibility_changed.connect(_on_visibility_changed)
	
func _process(delta: float) -> void:
	self.global_position = Vector2.ZERO
	self.global_rotation = 0.0;
	var i = 0
	while i < get_point_count():
		if point_age[i] > point_duration:
			remove_point(0);
			point_age.remove_at(0)
		else:
			point_age[i] += delta	
		i += 1
	create_point(agent.global_position, delta)

func _on_visibility_changed() -> void:
	self.process_mode = Node.PROCESS_MODE_INHERIT if self.visible else Node.PROCESS_MODE_DISABLED
	clear_points()
	
func create_point(parent_position: Vector2, time_delta: float) -> void:
	if last_point_position:
		var distance := parent_position.distance_to(last_point_position)
		if distance < min_spawn_dist:
			return
		var point_count = get_point_count()
		if (point_count > 2 && distance > max_spawn_dist):
			var seconde_last_point_position = get_point_position(point_count - 2);
			last_point_position = get_point_position(point_count - 1);
			for num: float in range(int(max_spawn_dist), int(distance - min_spawn_dist), int(max_spawn_dist)):
				var num2 := 0.5 + num / distance * 0.5
				var vector := seconde_last_point_position.lerp(last_point_position, num2)
				var to := last_point_position.lerp(seconde_last_point_position, num2)
				var position_ = vector.lerp(to, num2)
				point_age.append(time_delta * num2)
				add_point(position_)
	point_age.append(0.0)
	add_point(parent_position)
	last_point_position = parent_position
