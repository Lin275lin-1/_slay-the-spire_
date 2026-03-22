class_name Intents
extends HBoxContainer

# 暂时的
const IntentUi = preload("res://scenes/combat_ui/intent_ui.tscn")


var intent: Intent

func update_intent(intent_: Intent) -> void:
	var new_uis :int = intent_.sub_intents.size() - get_child_count()
	new_uis = clampi(new_uis, 0, new_uis)
	for i in range(new_uis):
		add_child(IntentUi.instantiate())
	var sub_intent: SubIntent
	for i in range(intent_.sub_intents.size()):
		sub_intent = intent_.sub_intents[i]
		get_child(i).update_display(sub_intent.icon, sub_intent.get_text())
		get_child(i).show()
func hide_intent() -> void:
	for child: IntentUI in get_children():
		child.hide()
