class_name BuffUI
extends TextureRect

var buff: Buff
@onready var stack_label: Label = $StackLabel

func _ready() -> void:
	texture = buff.icon
	update_stack()
	buff.stack_changed.connect(update_stack)
	buff.tree_exited.connect(_on_buff_removed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func update_stack():
	if stack_label:
		stack_label.text = str(buff.stacks) if buff.stacks > 1 else ""
	
func _on_buff_removed() -> void:
	queue_free()

func _on_mouse_entered():
	if buff:
		TooltipManager.show_tooltip(buff.get_description())

func _on_mouse_exited():
	if buff:
		TooltipManager.hide_tooltip()
