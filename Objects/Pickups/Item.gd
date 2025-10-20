class_name Item
extends Area2D

@export var item_name : String

var item_exists : bool = true

func pickup() -> void:
	if item_exists:
		item_exists = false
		$Item.queue_free()
