extends Node2D

# A horde survival game by Leo Torrijos
# Attack enemies that spawn in by dashing into them.
#
# Controls:
# Arrows - Move
# Z - Dash

var spawn_effect = preload("res://extras/Arena Survival/enemy/SpawnEffect.tscn")

var enemy = {
	0 : preload("res://extras/Arena Survival/enemy/BasicEnemy.tscn"),
	1 : preload("res://extras/Arena Survival/enemy/BigEnemy.tscn"),
	2 : preload("res://extras/Arena Survival/enemy/ScaryEnemy.tscn"),
			}

var danger = 0
var spawn_amount = 2

var scary_cooldown = 0


func spawn_enemy(pos):
	var random_enemy = randi_range(0, 2)
	
	# Only spawn a dangerous enemy later and infrequently.
	if random_enemy == 2:
		if danger > 10:
			if scary_cooldown > 0:
				random_enemy = 0
				scary_cooldown -= 1
			else:
				scary_cooldown = 6
		else:
			random_enemy = 0
	
	var new_enemy = enemy[random_enemy].instantiate()
	new_enemy.global_position = pos
	new_enemy.player = $ArenaPlayer
	$Enemies.add_child(new_enemy)


func _on_spawn_timer_timeout():
	danger += 1
	for i in spawn_amount:
		pick_location()
	
	if danger % 10 == 0:
		spawn_amount += 1
		$SpawnTimer.wait_time += 1

func pick_location():
	var effect = spawn_effect.instantiate()
	effect.position = Vector2(32 + randi_range(0, 200), 32 + randi_range(0, 144))
	add_child(effect)


func _on_death_timer_timeout():
	get_tree().reload_current_scene()
