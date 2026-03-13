class_name CardState
extends Node
## 卡牌状态机中状态的基类

## BASE:基础状态 
## CLICKED:鼠标点击后的状态 
## DRAGGING: 非指向性卡牌被拖拽后的状态
## AIMING: 指向性卡牌被拖拽后的状态
## RELEASED: 卡牌被打出时的状态
enum STATE {BASE, CLICKED, DRAGGING, AIMING, RELEASED}

@export var state: STATE

var card_ui: CardUI

# 状态切换时释放该信号，CardStateMachine负责接受并处理
@warning_ignore("unused_signal")
signal card_state_machine_change_state_requested(from: CardState, to: CardState.STATE)

func enter_state() -> void:
	pass

func exit_state() -> void:
	pass

func on_gui_input(event: InputEvent) -> void:
	pass

func on_input(event: InputEvent) -> void:
	pass

func on_mouse_entered() -> void:
	pass

func on_mouse_exited() -> void:
	pass
