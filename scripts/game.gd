extends Node2D

signal open_menu()
signal close_menu()
signal open_win_screen()
signal open_lose_screen(end_message)

@export var enemy_scene: PackedScene
@export var enemy_count: int

@onready var game = $"."
@onready var gui = $GUI
@onready var camera_2d = $Camera2D
@onready var player = $Player
@onready var start_timer = $start_timer
@onready var music = $Music

var score = 0
var combo = 0
var multiplier = 1.0
var min_multiplier = 1.0
var starting_enemies: int
var enemies_left: int
var lost = false
var won = false
var round_number = 0

var max_multiplier: float = 1.0
var max_combo: int = 0
var enemies_killed: int = 0


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	music.get_child(1).set_volume_db(-80)
	music.get_child(2).set_volume_db(-80)


func _input(event):
	if event.is_action_pressed('ui_cancel') && !get_tree().paused:
		pause()
	elif event.is_action_pressed('ui_cancel') && get_tree().paused:
		unpause()


func _start_game():
	round_number += 1
	spawn_enemies(prepare_enemy_count())
	update_score()
	update_multiplier()


func prepare_enemy_count():
	if round_number % 5 == 1 and round_number != 1:
		print("EYOO")
	
	enemy_count =  3 + pow(float(round_number%5),2.0)
	starting_enemies = enemy_count
	enemies_left = enemy_count
	return enemy_count


func update_score(points = 0):
	score += (points * multiplier)
	gui.update_score(score)


func update_multiplier(points = 0.0):
	multiplier = multiplier + points
	if multiplier > max_multiplier:
		max_multiplier = multiplier
	gui.update_multiplier(multiplier)


func increase_combo():
	combo += 1
	if combo > max_combo:
		max_combo = combo
	
	if combo > 10:
		music.get_child(0).set_volume_db(3)
		music.get_child(1).set_volume_db(3)
		
	if combo > 20:
		music.get_child(0).set_volume_db(6)
		music.get_child(1).set_volume_db(6)
		music.get_child(2).set_volume_db(6)
	
	update_combo(combo)


func reset_combo():
	music.get_child(0).set_volume_db(0)
	music.get_child(1).set_volume_db(-80)
	music.get_child(2).set_volume_db(-80)
	update_combo(0)


func update_combo(count):
	combo = count
	gui.update_combo(combo)


func spawn_enemies(count):
	for each in count:
		var mob = enemy_scene.instantiate()
		var mob_position = _get_random_position()
		mob.position = mob_position
		mob.connect("killed_by_player", _on_enemy_killed_by_player)
		mob.connect("player_hit", _on_enemy_deals_damage)
		add_child(mob)


func _on_enemy_killed_by_player(_points, _multiplier):
	enemies_left -= 1
	enemies_killed += 1
	update_score(_points)
	update_multiplier(_multiplier)
	increase_combo()
	camera_2d.apply_shake(1.5,1)
	if enemies_left <= 0:
		won = true
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
	get_tree().paused = true
	open_menu.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func unpause():
	get_tree().paused = false
	close_menu.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_enemy_deals_damage():
	reset_combo()
	multiplier = 1.0
	gui.update_multiplier(multiplier)
	player.get_damaged()
	gui.update_health_bar()


func end_stage():
	if lost:
		game_lost()
	elif won:
		stage_won()


func _on_player_died():
	lost = true
	end_stage()


func restart():
	lost = false
	won = false
	player.visible = true


func _on_menu_unpause():
	unpause()


func _on_start_timer_start_game():
	_start_game()


func stage_won():
	get_tree().paused = true
	open_win_screen.emit()


func _on_win_screen_hide_ui():
	gui.hide()


func _on_win_screen_next_round():
	gui.show()
	get_tree().paused = false
	_start_game()


func game_lost():
	var end_message = str(
		"SCORE: %d\n" % score,
		"MAX MULTIPLIER: %.02f\n" % max_multiplier,
		"MAX COMBO: %d\n" % max_combo,
		"ENEMIES VANQUISHED: %d\n" % enemies_killed,
		"ROUNDS: %d" % round_number
	)
	gui.hide()
	get_tree().paused = true
	open_lose_screen.emit(end_message)


func _on_options_unpause():
	unpause()
