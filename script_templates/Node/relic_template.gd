extends Relic

func initialize_relic(_owner: RelicUI) -> void:
	print("初始化")
	
func activate_relic(_owner: RelicUI) -> void:
	print("遗物触发逻辑")

func deactivate_relic(_owner: RelicUI) -> void:
	print("如果由事件驱动，在这里解除")
