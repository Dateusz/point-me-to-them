extends CanvasLayer

signal start_game()

@onready var label = $Label
@onready var timer = $Timer


func _ready():
	timer.start()


func time_left():
	var time_left = timer.time_left
	var second =  (int(time_left) % 60) + 1
	return [second]
	
func _process(delta):
	label.text = "%02d" % time_left()


func _on_timer_timeout():
	label.set_visible(false)
	start_game.emit()
