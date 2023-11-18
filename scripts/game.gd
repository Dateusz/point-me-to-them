extends Node2D

signal open_menu()
signal close_menu()

@export var enemy_scene: PackedScene
@export var enemy_count: int

@onready var game = $"."
@onready var gui = $GUI
@onready var camera_2d = $Camera2D
@onready var player = $Player

var score = 0
var combo = 0
var multiplier = 1.0
var min_multiplier = 1.0
var starting_enemies = enemy_count
var lost = false
var won = false


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_start_game()


func _input(event):
	if event.is_action_pressed('ui_cancel') && !get_tree().paused:
		pause()
	elif event.is_action_pressed('ui_cancel') && get_tree().paused:
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
		mob.connect("player_hit", _on_enemy_deals_damage)
		add_child(mob)


func _on_enemy_killed_by_player(_points, _multiplier):
	enemy_count -= 1
	update_score(_points)
	update_multiplier(_multiplier)
	update_combo()
	camera_2d.apply_shake(1.5,1)
	if enemy_count <= 0:
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
	combo = 0
	multiplier = 1.0
	gui.update_multiplier(multiplier)
	gui.update_combo(combo)
	player.get_damaged()
	gui.update_health_bar()


func end_stage():
	if lost:
		print("game lost")
	elif won:
		print("game won")


func _on_player_died():
	if !lost:
		lost = true
		end_stage()


func restart():
	lost = false
	won = false
	player.visible = true



func _on_menu_unpause():
	unpause()
