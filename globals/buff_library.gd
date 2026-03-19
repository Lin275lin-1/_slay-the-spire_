extends Node

var buff_data = {
	"易伤": {
		"name": "易伤",
		"description": "受到的攻击伤害增加50%",
		"icon": preload("res://images/powers/vulnerable_power.png")
	},
	"虚弱": {
		"name": "虚弱",
		"description": "造成的攻击伤害减少25%",
		"icon": preload("res://images/powers/weak_power.png")
	},
	"中毒":{
		"name": "中毒",
		"description": "回合开始时失去{stacks}点生命，然后减少一层",
		"icon": preload("res://images/powers/poison_power.png")
	}
}

func get_description(buff_name: String, stacks: int) -> String:
	var buff_info = buff_data.get(buff_name, null)
	if buff_info:
		return buff_info["description"].format({"stacks":stacks})
	return ""
