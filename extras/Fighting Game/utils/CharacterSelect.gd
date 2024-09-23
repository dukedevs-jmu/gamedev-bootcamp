extends Control

var names = ["random", "fighting guy", "mr. shoe", "roboto", "ninja"]
var current_char = 0

func _ready():
	update_name()

func _on_left_pressed():
	if current_char == 0:
		current_char = names.size() - 1
	else:
		current_char -= 1
	update_name()


func _on_right_pressed():
	if current_char == names.size() - 1:
		current_char = 0
	else:
		current_char += 1
	update_name()

func update_name():
	$Name.text = names[current_char]
