class_name BuffManager
extends Node

# 如果新增buff，返回0
func add_buff(buff_context: ApplyBuffContext) -> int:
	var buff_node: Buff = buff_context.buff_node
	var exist_buff: Buff = null;
	for child: Buff in get_children():
		if child.buff_name == buff_node.buff_name:
			exist_buff = child
			break
	if exist_buff:
		var buff_stacks = exist_buff.stacks
		exist_buff.add_stack(buff_context.amount)
		return buff_stacks
	else:
		
		buff_node.agent = buff_context.target
		add_child(buff_node)
		buff_node.stacks = buff_context.amount	
		return 0
