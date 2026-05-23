class_name ShopItem
extends RefCounted

#封装
var item_data            # 原始数据：Card / Relic / Potion
var shop_price: int
var on_sale: bool = false
var original_price: int = 0

func _init(data, price: int, sale: bool = false, orig_price: int = 0) -> void:
	item_data = data
	shop_price = price
	on_sale = sale
	original_price = orig_price
