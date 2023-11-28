extends Node2D

signal died()
signal health_bonus_gained()

@onready var game = $".."
@onready var player = $"."
@onready var character_body_2d = $CharacterBody2D
@onready var animated_sprite_2d = $CharacterBody2D/AnimatedSprite2D

@onready var gui = $"../GUI"
@onready var camera_2d = $"../Camera2D"

var cursor = preload("res://sprites/cursor.png")
@export var health: int = 5
var iframes_timer: Timer
var iframes_length: float = 1.0
var is_vulnerable = true
var skills: Array
var base_size: Vector2

var dmg_bonus: int = 0
var size_bonus: float = 0.0


func _ready():
	base_size = character_body_2d.transform.get_scale()
	print(base_size)


func _input(event):
	if health > 0:
		if event is InputEventMouseButton:
			print("Mouse Click/Unclick at: ", event.position)
		elif event is InputEventMouseMotion:
			player.position = event.position


func get_damaged():
	if is_vulnerable:
		SoundManager.play_player_hit_sound()
		camera_2d.apply_shake(30, 5)
		_new_iframes_timer(iframes_length)
		health -= 1
	
	if health < 1:
		died.emit()


func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "dead":
		player.visible = false


func _new_iframes_timer(time):
	if iframes_timer != null:
		iframes_timer.queue_free()
		
	iframes_timer = Timer.new()
	add_child(iframes_timer)
	iframes_timer.connect("timeout", _set_player_vulnerable)
	iframes_timer.set_wait_time(time) 
	iframes_timer.set_one_shot(true)
	iframes_timer.start()
	is_vulnerable = false


func _set_player_vulnerable():
	is_vulnerable = true


func _on_win_screen_add_skill(skill):
	skills.append(skill)
	_update_bonuses(skill)


func _update_bonuses(skill):
	if skill.skill_name == "Damage+":
		dmg_bonus += 1
		
	if skill.skill_name == "Size+":
		size_bonus += 0.02
			
		var size = (base_size.x + size_bonus)
		character_body_2d.scale = Vector2(size, size)
		
	if skill.skill_name == "Health+":
		health += 1
		health_bonus_gained.emit()
