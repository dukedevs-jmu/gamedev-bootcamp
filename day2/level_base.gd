extends Node2D

@export var next_level : PackedScene

func _on_goal_player_win():
	if next_level != null:
		get_tree().change_scene_to_packed_scene(next_level)
