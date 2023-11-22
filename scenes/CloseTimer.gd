extends Timer


@onready var timer = $"."
@onready var intermediate_text = $"../WinScreenCanvas/Control/IntermediateText"


func _process(_delta):
	if not timer.is_stopped():
		intermediate_text.text = "[center]Great! Continuing in %02d[/center]" % (get_time_left() + 1)

