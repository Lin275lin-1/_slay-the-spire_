extends Node

# 预加载自定义类型，确保在信号声明时能够识别


@warning_ignore_start("unused_signal")
## 卡牌相关
signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)
signal card_click_started(card_ui: CardUI)
signal card_click_ended(card_ui: CardUI)
signal card_drag_started(card_ui: CardUI)
signal card_drag_ended(card_ui: CardUI)
signal card_previewed(card_ui: CardUI, to_preview: bool)
signal before_card_played(card: Card, card_context: Dictionary)
signal card_played(card: Card)
signal card_exhausted(card: Card)
signal target_selected(target: Creature, card: Card)
signal target_unselected(card: Card)
## 药水相关
signal potion_aim_started(potion_ui: PotionUI)
signal potion_aim_ended(potion_ui: PotionUI)
signal before_potion_used(potion_ui: PotionUI)
signal after_potion_used(potion_ui: PotionUI)
## 技能相关
signal before_skill_played(skill: Skill)
signal skill_played(skill: Skill)
signal skill_aim_started(skill_ui: MainSkillUI)
signal skill_aim_ended(skill_ui: MainSkillUI)
## 玩家相关
# 玩家回合开始抽牌后
signal player_hand_drawn
signal player_hand_discarded
signal player_turn_started
signal player_turn_ended
signal player_talked(text: String, time: float)
signal player_died
signal player_hit
## 敌人相关
signal enemy_action_completed(enemy: Enemy)
signal enemy_turn_ended
signal enemy_died
## 提示栏相关
signal tooltip_show_request(node: Node, callback: Callable)
signal tooltip_hide_request 
## 战斗相关
signal combat_start
signal combat_won
## 测试用
signal shop_exited
signal campfire_exited
signal combat_reward_exited
signal treasure_room_exited
signal incident_exited
signal map_exited
@warning_ignore_restore("unused_signal")

##地图房间
signal map_room_selected(room: Room)
