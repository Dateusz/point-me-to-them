extends Camera2D

@export var strength: float = 30.0
@export var shake_fade: float = 5.0

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var shake_option: float = 1.0


func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		apply_shake(strength, shake_fade)
		
	if shake_strength > 1:
		shake_strength = lerpf(shake_strength,0,shake_fade * delta)
		offset = random_offset()
		
	if shake_strength < 1:
		shake_strength = 0

func apply_shake(applied_strength, applied_shake):
	shake_strength = applied_strength * shake_option
	shake_fade = applied_shake


func random_offset() -> Vector2:
	return Vector2(
		rng.randf_range(-shake_strength, shake_strength),
		rng.randf_range(-shake_strength, shake_strength)
	)


func _on_cam_shake_slider_value_changed(value):
	shake_option = value
