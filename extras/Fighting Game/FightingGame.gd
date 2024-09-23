extends Node2D

# A basic fighting game by Leo Torrijos.
#
# Contains 4 playable characters and an AI opponent.
#
# Controls:
# Left, Right - Movement
# Z - Light Attack
# Z + Hold Up - Heavy Attack
# Hold Down - Block
# Space - Jump

var player1 = null
var player2 = null

var characters = {
	1 : preload("res://extras/Fighting Game/characters/FightingGuy.tscn"),
	2 : preload("res://extras/Fighting Game/characters/MrShoe.tscn"),
	3 : preload("res://extras/Fighting Game/characters/Roboto.tscn"),
	4 : preload("res://extras/Fighting Game/characters/Ninja.tscn"),
}


func _on_start_pressed():
	spawn_player(1, $UI/CharacterSelect1.current_char, false)
	spawn_player(2, $UI/CharacterSelect2.current_char, true)
	$Music.play()
	$UI.hide()

func spawn_player(player_id, character, bot):
	# Random character
	if character == 0:
		character = randi_range(1, characters.size())
	
	var fighter = characters[character].instantiate()
	fighter.connect("health_change", health_change)
	match player_id:
		1:
			fighter.position = Vector2(128, 256)
			player1 = fighter
		2:
			fighter.position = Vector2(512, 256)
			fighter.get_node("Sprite2D").scale.x = -1
			fighter.direction = -1
			player2 = fighter
		
	if bot:
		fighter.set_script(load("res://extras/Fighting Game/characters/BotFighter.gd"))
		if player_id == 1:
			fighter.target = player2
		else:
			fighter.target = player1
			

	add_child(fighter)

func health_change():
	$HP1.value = player1.health
	$HP2.value = player2.health
	
	if player2.health <= 0:
		$WinText.text = "p1 wins!!"
		$Restart.show()
	elif player1.health <= 0:
		$WinText.text = "p2 wins!!"
		$Restart.show()


func _on_restart_pressed():
	get_tree().reload_current_scene()
