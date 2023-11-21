extends CanvasLayer

signal start_game()

@onready var label = $Label
@onready var timer = $Timer


func _ready():
	timer.start()

	
func _process(_delta):
	label.text = "%02d" % (timer.get_time_left() + 1)


func _on_timer_timeout():
	label.set_visible(false)
	start_game.emit()
