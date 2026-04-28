## 房间奖励的上下文
class_name RewardContext
extends RefCounted

var extra_card_count := 0
var extra_potion_count := 0
var extra_relic_count := 0

var upgrade_attack := false
var upgrade_skill := false
var upgrade_power := false
var upgrade_all := false

var extra_gold: Array[int] = []

var all_rare := false
var all_uncommon := false
var all_common := false
