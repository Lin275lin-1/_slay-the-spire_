extends CardState


func enter_state() -> void:
	card_ui.state_label.text = "BASE"
	# 在clicked z_index会设为1以在其他卡上方展示
	card_ui.z_index = 0

func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left mouse"):
		card_state_machine_change_state_requested.emit(self, STATE.CLICKED)

func exit_state() -> void:
	pass
