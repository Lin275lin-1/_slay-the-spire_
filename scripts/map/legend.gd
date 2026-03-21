class_name Legend
extends Control

signal highlight_requested(type: int)
signal highlight_cleared

func _ready():
	# 假设每个 TextureRect 的名称为 MonsterIcon、ShopIcon 等
	$legend_item/MonsterEntry/MonsterIcon.mouse_entered.connect(_on_icon_entered.bind(Room.Type.MONSTER))
	$legend_item/MonsterEntry/MonsterIcon.mouse_exited.connect(_on_icon_exited)
	
	$legend_item/ShopEntry/ShopIcon.mouse_entered.connect(_on_icon_entered.bind(Room.Type.SHOP))
	$legend_item/ShopEntry/ShopIcon.mouse_exited.connect(_on_icon_exited)
	
	$legend_item/CampfireEntry/CampfireIcon.mouse_entered.connect(_on_icon_entered.bind(Room.Type.CAMPFIRE))
	$legend_item/CampfireEntry/CampfireIcon.mouse_exited.connect(_on_icon_exited)
	
	$legend_item/TreasureEntry/TreasureIcon.mouse_entered.connect(_on_icon_entered.bind(Room.Type.TREASURE))
	$legend_item/TreasureEntry/TreasureIcon.mouse_exited.connect(_on_icon_exited)
	
	$legend_item/BossEntry/BossIcon.mouse_entered.connect(_on_icon_entered.bind(Room.Type.BOSS))
	$legend_item/BossEntry/BossIcon.mouse_exited.connect(_on_icon_exited)
	
	$legend_item/EliteEntry/EliteIcon.mouse_entered.connect(_on_icon_entered.bind(Room.Type.ELITE))
	$legend_item/EliteEntry/EliteIcon.mouse_exited.connect(_on_icon_exited)
	
	$legend_item/UnknownEntry/UnkonwnIcon.mouse_entered.connect(_on_icon_entered.bind(Room.Type.UNKNOWN))
	$legend_item/UnknownEntry/UnkonwnIcon.mouse_exited.connect(_on_icon_exited)

func _on_icon_entered(type: int):
	#print("进入图标，类型: ", type) 
	highlight_requested.emit(type)

func _on_icon_exited():
	#print("离开图标")   
	highlight_cleared.emit()
