class_name DrawCardEffect
extends Effect

func execute(context: Context) -> Variant:
	await context.source.draw_cards(context)
	return null
