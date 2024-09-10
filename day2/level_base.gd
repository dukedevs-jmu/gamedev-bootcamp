extends Node2D

@export_file var next_level

func _on_goal_player_win():
	if next_level != null:
		get_tree().change_scene_to_file(next_level)
