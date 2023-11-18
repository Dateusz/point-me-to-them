extends Node2D

signal killed_by_player(points, multiplier_bonus)
signal player_hit()

@export var resource: Resource

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var health: int
@onready var points: int
@onready var multiplier_bonus: float
@onready var attack_collision_area = $AttackCollisionArea
@onready var damage: int

var take_damage = false
var _damage_timer = null
var _attack_timer = null
var is_dead = false
var is_attacking = false
var is_vulnerable = true
var min_attack_wait_time
var max_attack_wait_time
var attack_speed

func _ready():
	$AnimatedSprite2D.sprite_frames = resource.sprite_frames
	health = resource.health
	points = resource.points_reward
	multiplier_bonus = resource.multiplier_bonus
	damage = resource.damage
	min_attack_wait_time = resource.attack_speed[0]
	max_attack_wait_time = resource.attack_speed[1]
	
	animated_sprite_2d.play("idle")
	_new_timer(_attack_timer, _get_attack_speed(), _attack)


func _process(_delta):
	_check_if_dead()


func _on_area_2d_body_entered(_body):
	if !is_dead:
		take_damage = true
		_take_damage()
		_new_timer(_damage_timer, 1.0, _take_damage)


func _on_area_2d_body_exited(_body):
	take_damage = false
	if (
		_damage_timer != null 
		&& !_damage_timer.is_stopped()
	):
		_damage_timer.stop()
		_damage_timer.queue_free()


func _take_damage():
	if take_damage:
		play_hit_sound()
		if not is_attacking:
			animated_sprite_2d.play("hit")
		health -= 1


func _check_if_dead():
	if health <= 0:
		take_damage = false
		is_dead = true
		animated_sprite_2d.play("die")


func _new_timer(timer, time, method):
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", method)
	timer.set_wait_time(time) 
	timer.set_one_shot(false)
	timer.start()


func _on_animated_sprite_2d_animation_finished():
	if is_dead:
		queue_free()
	if animated_sprite_2d.animation == "hit":
		animated_sprite_2d.play("idle")
	if animated_sprite_2d.animation == "attack":
		is_attacking = false
		is_vulnerable = true


func _on_animated_sprite_2d_animation_changed():
	if animated_sprite_2d.animation == "die":
		killed_by_player.emit(points, multiplier_bonus)


func play_hit_sound():
	SoundManager.play_skeleton_hit_sound()


func _attack():
	if !is_dead:
		is_attacking = true
		is_vulnerable = false
		animated_sprite_2d.play("attack")


func _get_attack_speed():
	attack_speed = randf_range(min_attack_wait_time, max_attack_wait_time)
	return attack_speed


func _on_animated_sprite_2d_frame_changed():
	if (
		is_attacking
		&& animated_sprite_2d.animation == "attack"
		&& animated_sprite_2d.frame == 7
		):
			attack_collision_area.monitoring = true
	else:
		attack_collision_area.monitoring = false


func _on_attack_collision_area_body_entered(_body):
	player_hit.emit()
