class_name SubSkill
extends Skill

## 副技能的cd(回合)
@export var cd: int

var current_cd = 0

func available() -> bool:
	return current_cd == cd
	
