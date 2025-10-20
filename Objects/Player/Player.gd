extends CharacterBody2D

## I'm going to have the Player code exclusively handle parameters that we need to 
## transfer between levels. 

var has_horns = false
var has_eyes = false
var has_knife = false

#@onready var pID = self.get_instance_id()

signal _pickup
signal meowed

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Exit"):
		get_tree().quit()

func _on_pickup_area_area_entered(item: Area2D) -> void:
	if is_instance_of(item, Item):
		match item.item_name:
			"horns":
				print("Picking up horns!")
				has_horns = true
				item.get_node("Item").queue_free()
				_pickup.emit()
			"eyes":
				print("Picking up eyes!")
				has_eyes = true
				item.get_node("Item").queue_free()
				_pickup.emit()
			"knife":
				print("Picking up knife!")
				has_knife = true
				item.get_node("Item").queue_free()
				_pickup.emit()


func _ready() -> void:
	for door in get_tree().get_nodes_in_group("doors"):
		if !is_connected("meowed", Callable(door, "_on_door_meowed")):
			self.connect("meowed", Callable(door, "_on_door_meowed"))


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Meow"):
		%MeowPlayer.play()
		await get_tree().create_timer(%MeowPlayer.stream.get_length()).timeout
		meowed.emit()
	
	
