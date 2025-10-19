extends Node

var player : AudioStreamPlayer

func _ready():
	player = AudioStreamPlayer.new()

	player.stream = load("res://Assets/Sound/Inspector Hound Main Theme FINAL.wav")
	
	add_child(player)
	
	player.play()
