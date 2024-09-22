extends Node2D

@export var distance = 2000
var can_move = false

func _physics_process(delta):
	if position.x < 2000 and can_move:
		position.x += 2


func _on_start_delay_timeout():
	can_move = true
