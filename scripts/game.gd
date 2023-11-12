extends Node2D

@export var enemy_scene: PackedScene
@export var enemy_count: int

@onready var game = $"."
@onready var gui = $GUI

var score = 0
var combo = 0
var multiplier = 1.0
var min_multiplier = 1.0
var starting_enemies = enemy_count
var game_paused = false


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_start_game()


func _input(event):
	if event.is_action_pressed('ui_cancel') && !game_paused:
		pause()
	elif event.is_action_pressed('ui_cancel') && game_paused:
		unpause()


func _start_game():
	spawn_enemies(enemy_count)
	update_score()
	update_multiplier()


func update_score(points = 0):
	score += (points * multiplier)
	gui.update_score(score)


func update_multiplier(points = 0.0):
	multiplier = multiplier + points
	gui.update_multiplier(multiplier)


func update_combo():
	combo += 1
	gui.update_combo(combo)
	

func spawn_enemies(count):
	for each in count:
		var mob = enemy_scene.instantiate()
		var mob_position = _get_random_position()
		mob.position = mob_position
		mob.connect("killed_by_player", _on_enemy_killed_by_player)
		add_child(mob)


func _on_enemy_killed_by_player(_points, _multiplier):
	enemy_count -= 1
	update_score(_points)
	update_multiplier(_multiplier)
	update_combo()
	if enemy_count <= 0:
		end_stage()


func _get_random_position():
	var screen_center = get_viewport_rect().size / 2.0
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var _x = rng.randfn(100, 80.0)
	var _y = rng.randfn(100, 80.0)
	var _sign_x = pow(-1, randi() % 2)
	var _sign_y = pow(-1, randi() % 2)
	var _result_x = int(clamp(_x, 0, 500))
	var _result_y = int(clamp(_y, 0, 500))
	var mob_x = screen_center[0] + (_x * _sign_x)
	var mob_y = screen_center[1] + (_y * _sign_y)
	
	return Vector2(mob_x, mob_y)


func pause():
	game_paused = true
	get_tree().paused = true


func unpause():
	game_paused = false
	get_tree().paused = false


func end_stage():
	# change music track to something slower
	# if perfect (combo == number of enemies) some popup or whatever
	# "WIN SCREEN":
	# choose an ability
	# continue afterwards
	pass
