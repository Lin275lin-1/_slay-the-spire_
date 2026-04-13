extends Node2D

@onready var text_label: RichTextLabel = $DialogueBox/MarginContainer/Text

var timer: Timer
var tween: Tween
var typewriter_timer: Timer

# 可配置参数
@export var type_speed: float = 0.03           # 每个字符显示间隔（秒）
@export var fade_duration: float = 0.2         # 淡入/淡出时长
@export var random_x_range_left: float = 900.0       
@export var random_x_range_right: float = 100.0   

var base_position: Vector2                     # 记录基准位置

func _ready() -> void:
	visible = false
	modulate.a = 0.0
	
	# 保存初始位置作为基准（由外部设置或编辑器预设）
	base_position = position
	
	# 自动隐藏计时器
	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(_on_timeout)
	add_child(timer)
	
	# 打字机效果计时器
	typewriter_timer = Timer.new()
	typewriter_timer.one_shot = false
	typewriter_timer.wait_time = type_speed
	typewriter_timer.timeout.connect(_on_typewriter_step)
	add_child(typewriter_timer)

func say(message: String, duration: float = 2.0) -> void:
	if not text_label:
		return
	
	# 停止所有正在运行的动画和计时器
	_kill_all_tweens_and_timers()
	
	# 设置文本内容，重置可见字符数
	text_label.text = message
	text_label.visible_characters = 0
	
	# 横向随机偏移
	var random_offset = Vector2(randf_range(-random_x_range_left, random_x_range_right), 0)
	position = base_position + random_offset
	
	# 开始淡入动画
	visible = true
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, fade_duration)
	
	# 启动打字机效果
	typewriter_timer.start()
	
	# 设置自动隐藏计时器（从打字完成后开始算？这里简化：总显示时长 = duration）
	# 注意：duration 应该包含打字时间，但我们可以简单在打字开始后 duration 秒隐藏
	timer.wait_time = duration
	timer.start()

func _on_typewriter_step() -> void:
	if not text_label:
		return
	
	text_label.visible_characters += 1
	
	# 如果所有字符都已显示，停止打字机计时器
	if text_label.visible_characters >= text_label.text.length():
		typewriter_timer.stop()

func _on_timeout() -> void:
	# 淡出并隐藏
	_kill_all_tweens_and_timers()
	
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, fade_duration)
	tween.tween_callback(func(): 
		visible = false
		# 恢复基准位置
		position = base_position
	)

func _kill_all_tweens_and_timers() -> void:
	if tween and tween.is_valid():
		tween.kill()
	if timer:
		timer.stop()
	if typewriter_timer:
		typewriter_timer.stop()
