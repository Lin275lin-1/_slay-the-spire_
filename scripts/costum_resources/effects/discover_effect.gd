class_name DiscoverEffect
extends Effect

func execute(context: Context) -> Variant:
	for target: Creature in context.targets:
		if not target:
			continue
		if target is Player:
			target.discover_card(context)
	return null
