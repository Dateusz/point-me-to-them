extends Node2D

signal died()

@onready var game = $".."
@onready var player = $"."
@onready var animated_sprite_2d = $CharacterBody2D/AnimatedSprite2D

@onready var gui = $"../GUI"
@onready var camera_2d = $"../Camera2D"

var cursor = preload("res://sprites/cursor.png")
@export var health: int = 5
var iframes_timer: Timer
var iframes_length: float = 1.0
var is_vulnerable = true
var skills: Array

var dmg_bonus: int = 0
var health_bonus: int = 0
var size_bonus: float = 1.0


func _ready():
	pass


func _input(event):
	if health > 0:
		if event is InputEventMouseButton:
			print("Mouse Click/Unclick at: ", event.position)
		elif event is InputEventMouseMotion:
			player.position = event.position

func get_damaged():
	if health > 0:
		if is_vulnerable:
			SoundManager.play_player_hit_sound()
			camera_2d.apply_shake(30, 5)
			health -= 1
			_new_iframes_timer(iframes_length)
	else:
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
	_update_bonuses()


func _update_bonuses():
	dmg_bonus = 0
	health_bonus = 0;
	size_bonus = 1.0
	for skill in skills:
		if skill.skill_name == "Damage+":
			dmg_bonus += 1
		if skill.skill_name == "Size+":
			size_bonus += 0.5
		if skill.skill_name == "Health+":
			health_bonus += 1
		
	print("damage bonus: %s" % dmg_bonus)
	print("health bonus: %s" % health_bonus)
	print("size bonus: %s" % (size_bonus - 1.0))
	
