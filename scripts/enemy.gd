extends Node2D

signal killed_by_player(points, multiplier_bonus)

@export var resource: Resource

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var health: int
@onready var points: int
@onready var multiplier_bonus: float

var take_damage = false
var _timer = null
var is_dead = false

func _ready():
	$AnimatedSprite2D.sprite_frames = resource.sprite_frames
	animated_sprite_2d.play("idle")
	health = resource.health
	points = resource.points_reward
	multiplier_bonus = resource.multiplier_bonus


func _process(_delta):
	_check_if_dead()


func _on_area_2d_body_entered(_body):
	if !is_dead:
		take_damage = true
		_take_damage()
		_new_timer(1.0, _take_damage)


func _on_area_2d_body_exited(_body):
	take_damage = false
	if (
		_timer != null 
		&& !_timer.is_stopped()
	):
		_timer.stop()
		_timer.queue_free()


func _take_damage():
	if take_damage:
		play_hit_sound()
		animated_sprite_2d.play("hit")
		health -= 1


func _check_if_dead():
	if health <= 0:
		take_damage = false
		is_dead = true
		animated_sprite_2d.play("die")


func _new_timer(time, method):
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", method)
	_timer.set_wait_time(time) 
	_timer.set_one_shot(false)
	_timer.start()


func _on_animated_sprite_2d_animation_finished():
	if is_dead:
		queue_free()
	if animated_sprite_2d.animation == "hit":
		animated_sprite_2d.play("idle")


func _on_animated_sprite_2d_animation_changed():
	if animated_sprite_2d.animation == "die":
		killed_by_player.emit(points, multiplier_bonus)

func play_hit_sound():
	SoundManager.play_skeleton_hit_sound()
