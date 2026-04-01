extends EnemyAI

var last_action := ""
var roared := false

func execute_intent(source: Creature, target: Creature, current_intent: Intent) -> void:
	last_action = current_intent.intent_name
	super.execute_intent(source, target, current_intent)

func choose_intent(_source: Creature, _target: Creature) -> Intent:
	if last_action == "":
		return get_intent_by_name(intents, "Claw")
	var available_intents : Array[Intent] = []
	if not roared:
		available_intents.append(get_intent_by_name(intents, "Roar"))
	if last_action != "Claw":
		available_intents.append(get_intent_by_name(intents, "Claw"))
	if last_action != "RipAndTear":
		available_intents.append(get_intent_by_name(intents, "RipAndTear"))
	return random_intent(available_intents)
