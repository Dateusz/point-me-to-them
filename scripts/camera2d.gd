extends Camera2D

@export var strength: float = 30.0
@export var shake_fade: float = 5.0

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var shake_option: float = 1.0
var options_shake_value: float = 1.0


func _process(delta):
	if shake_strength > 1:
		shake_strength = lerpf(shake_strength,0,shake_fade * delta)
		offset = random_offset()
		
	if shake_strength < 1:
		shake_strength = 0

func apply_shake(applied_strength, applied_shake):
	shake_strength = applied_strength * options_shake_value
	shake_fade = applied_shake


func random_offset() -> Vector2:
	return Vector2(
		rng.randf_range(-shake_strength, shake_strength),
		rng.randf_range(-shake_strength, shake_strength)
	)


func _on_options_set_camera_shake(value):
	options_shake_value = value

