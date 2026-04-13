extends Node

# 结算栈(不允许外部访问
var _stack: Array[ResolutionEntry] = []
var is_resolving: bool = false

# 将卡牌加入结算栈，（卡牌调用play时加入）
func push_card(card: Card, context: Context):
	var entry = ResolutionEntry.new()
	entry.card = card
	entry.context = context
	entry.effect_index = 0
	_stack.append(entry)
	if not is_resolving:
		_resolve()
		
# 不断从栈顶取出effect并执行	
func _resolve():
	is_resolving = true
	while _stack.size() > 0:
		var entry = _stack[-1]
		# 卡牌所有效果完成后移出调用栈
		if entry.is_finished():
			_stack.pop_back()
			_on_card_finished(entry)
			continue
		await _execute_effect(entry.get_current_effect(), entry.context)
		if _should_stop():
			_clear_stack()
			break
		# 移动到下一个效果
		entry.effect_index += 1
	is_resolving = false
	
func _clear_stack() -> void:
	_stack.clear()	

# 判断执行是否应该终止,如杀死所有敌人时
func _should_stop() -> bool:
	return false

func _execute_effect(effect: Effect, context: Context) -> void:
	# 如果execute是同步函数会直接忽略await
	await effect.execute(context)
	
func _on_card_finished(entry: ResolutionEntry) -> void:
	Events.card_played.emit(entry.card)
	
