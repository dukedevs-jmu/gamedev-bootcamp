extends Area2D

var shatter = preload('res://extras/RPG Demo/objects/pot/ShatterEffect.tscn')

func _on_area_entered(area):
	var s = shatter.instantiate()
	s.position = global_position + Vector2(0, 4)
	get_parent().add_child(s)
	queue_free()
