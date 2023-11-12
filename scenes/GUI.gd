extends CanvasLayer

@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")

@onready var gui = $"."
@onready var score_display = $ScoreDisplay
@onready var multiplier_display = $MultiplierDisplay
@onready var combo_display = $ComboDisplay
@onready var menu = $Menu


func _ready():
	combo_display.set_visible(false)


func _input(event):
	if event.is_action_pressed('ui_cancel'):
		gui.get_node('Menu').visible = !gui.get_node('Menu').visible


func update_score(score):
	score_display.set_text(str("SCORE: ", score))

func update_multiplier(multiplier):
	multiplier_display.set_text("MULTIPLIER: %.02f" % multiplier)


func update_combo(combo):
	combo_display.set_text("COMBO X%1d" % combo)
	if (combo > 0):
		combo_display.set_visible(true)
	else:
		combo_display.set_visible(false)

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, value < .05)


func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_ID, value < .05)
