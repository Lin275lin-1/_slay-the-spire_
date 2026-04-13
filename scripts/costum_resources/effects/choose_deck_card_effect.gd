class_name ChooseDeckCardEffect
extends Effect

# 感觉这个effect不是很必要
func execute(context: Context) -> Variant:
	await context.source.select_deck(context)
	return null
