extends StaticBody2D

var in_range : bool = false
var opened : bool = false

@onready var doorId = self.get_instance_id()

func _ready() -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.get_instance_id() == $"../Player".get_instance_id()):
		in_range = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if(body.get_instance_id() == $"../Player".get_instance_id()):
		in_range = false


func _on_door_meowed() -> void:
	if (in_range):
		if !opened:
			opened = true
			$DoorCollision.set_deferred("disabled", true)
			# play door open sound
			$AnimatedSprite2D.play("opening")
		else:
			_on_door_close()

#making this a separate function in case I decide to have doors automatically close
func _on_door_close() -> void: 
	opened = false
	$DoorCollision.set_deferred("disabled", false)
	# play door close sound
	$AnimatedSprite2D.play("closing")
