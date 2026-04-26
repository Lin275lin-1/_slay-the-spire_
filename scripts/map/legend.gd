class_name Legend
extends Control

signal highlight_requested(type: int)
signal highlight_cleared

func _ready():
	# 假设每个 TextureRect 的名称为 MonsterIcon、ShopIcon 等
	$MonsterIcon.mouse_entered.connect(_on_icon_entered.bind(Room.Type.MONSTER))
	$MonsterIcon.mouse_exited.connect(_on_icon_exited)
	
	$ShopIcon.mouse_entered.connect(_on_icon_entered.bind(Room.Type.SHOP))
	$ShopIcon.mouse_exited.connect(_on_icon_exited)
	
	$CampfireIcon.mouse_entered.connect(_on_icon_entered.bind(Room.Type.CAMPFIRE))
	$CampfireIcon.mouse_exited.connect(_on_icon_exited)
	
	$ChestIcon.mouse_entered.connect(_on_icon_entered.bind(Room.Type.TREASURE))
	$ChestIcon.mouse_exited.connect(_on_icon_exited)
	
	#$BossIcon.mouse_entered.connect(_on_icon_entered.bind(Room.Type.BOSS))
	#$BossIcon.mouse_exited.connect(_on_icon_exited)
	#
	$EliteIcon.mouse_entered.connect(_on_icon_entered.bind(Room.Type.ELITE))
	$EliteIcon.mouse_exited.connect(_on_icon_exited)
	
	$UnkonwnIcon.mouse_entered.connect(_on_icon_entered.bind(Room.Type.UNKNOWN))
	$UnkonwnIcon.mouse_exited.connect(_on_icon_exited)

func _on_icon_entered(type: int):
	#print("进入图标，类型: ", type) 
	highlight_requested.emit(type)

func _on_icon_exited():
	#print("离开图标")   
	highlight_cleared.emit()
