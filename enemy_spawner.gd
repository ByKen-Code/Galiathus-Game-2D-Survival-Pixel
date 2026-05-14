extends Node2D

var enemy_scene = preload("res://musuh.tscn")
var wave = 1

@onready var spawn_points = [
	$Spawn1,
	$Spawn2,
	$Spawn3,
	$Spawn4,
	$Spawn5,
	$Spawn6,
	$Spawn7,
	$Spawn8,
	$Spawn9,
	$Spawn10
]

func _ready() -> void:
	start_waves()

func spawn_enemy(spawn_point):
	var enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_point.global_position + Vector2(
		randf_range(-20, 20),
		randf_range(-20, 20)
	)
	call_deferred("add_child", enemy)
	

func start_waves():
	var jumlah_musuh = wave * 2
	var avaiable_spawn = spawn_points.duplicate()	
	for i in range(jumlah_musuh):
		if avaiable_spawn.size() == 0:
			avaiable_spawn = spawn_points.duplicate()
		var random_spawn = avaiable_spawn.pick_random()
		avaiable_spawn.erase(random_spawn)
		spawn_enemy(random_spawn)
	

func _on_wave_timer_timeout() -> void:
	var musuh = get_tree().get_nodes_in_group("musuh")
	
	if musuh.size() == 0:
		wave += 1
		start_waves()
