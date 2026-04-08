class_name RunStats
extends Resource

signal gold_changed

signal floor_changed(new_floor: int)          # 楼层变化信号

const STARTING_GOLD:= 70

const BASE_CARD_REWARDS := 3;
const BASE_COMMON_WEIGHT := 6.0
const BASE_UNCOMMON_WEIGHT := 3.7
const BASE_RARE_WEIGHT := 0.3

@export var gold := STARTING_GOLD : set = set_gold

@export var card_rewards := BASE_CARD_REWARDS
@export_range(0.0,10.0)var common_weight := BASE_COMMON_WEIGHT
@export_range(0.0,10.0) var uncommon_weight := BASE_UNCOMMON_WEIGHT
@export_range(0.0,10.0) var rare_weight := BASE_RARE_WEIGHT

#地图数据
@export var map_data: Array[Array] = []   # 保存整个地图数据（Room 资源数组）
@export var floors_climbed: int = 0       # 已攀爬的层数（已解锁的最高楼层索引，0-based）

func set_gold(new_amount:int)->void:
	gold = new_amount
	gold_changed.emit()
	
func reset_weights()->void:
	common_weight=BASE_COMMON_WEIGHT
	uncommon_weight=BASE_UNCOMMON_WEIGHT
	rare_weight =BASE_RARE_WEIGHT

func set_floor(new_floor_climbed)->void:
	floors_climbed = new_floor_climbed
	floor_changed.emit(new_floor_climbed)
