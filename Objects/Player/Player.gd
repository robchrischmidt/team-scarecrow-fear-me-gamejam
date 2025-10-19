extends CharacterBody2D

signal meowed

func _ready() -> void:
	for door in get_tree().get_nodes_in_group("doors"):
		if !is_connected("meowed", Callable(door, "_on_door_meowed")):
			self.connect("meowed", Callable(door, "_on_door_meowed"))


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Meow"):
		#play meow
		await get_tree().create_timer(.2).timeout
		meowed.emit()
