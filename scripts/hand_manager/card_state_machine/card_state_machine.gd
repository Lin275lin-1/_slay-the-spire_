class_name CardStateMachine
extends Node
## 卡牌状态机

## 初始状态
@export var initial_state: CardState
## 绑定该状态机的卡牌
@export var card_ui: CardUI

## STATE与CardState的映射
var states: Dictionary[CardState.STATE, CardState]
var current_state: CardState: set = _set_card_state

func _ready() -> void:
	# card_ui会比状态机后加载，进行等待
	if not card_ui.is_node_ready():
		await card_ui.ready
	# 注册状态
	for child: CardState in get_children():
		if child is CardState:
			child.card_ui = card_ui
			child.card_state_machine_change_state_requested.connect(_on_card_state_machine_change_state_requested)
			states[child.state] = child
		if initial_state:
			initial_state.enter()
			current_state = initial_state

func on_mouse_entered() -> void:
	current_state.on_mouse_entered()

func on_mouse_exited() -> void:
	current_state.on_mouse_exited()

func on_input(event: InputEvent) -> void:
	current_state.on_input(event)

func on_gui_input(event: InputEvent) -> void:
	current_state.on_gui_input(event)

## current_state的setter
func _set_card_state(value: CardState) -> void:
	if current_state:
		current_state.exit_state()
	current_state = value
	current_state.enter_state()
	
## 卡牌状态切换的回调函数
func _on_card_state_machine_change_state_requested(from: CardState, to: CardState.STATE) -> void:
	if from != current_state:
		printerr("状态机出错")
		return
	
	var new_state := states[to]
	if not new_state:
		printerr("状态机出错")
		return
	
	if current_state:
		current_state.exit_state()
	
	new_state.enter()
	current_state = new_state
	
