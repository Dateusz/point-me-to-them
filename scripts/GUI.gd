extends CanvasLayer

@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")

@onready var gui = $"."
@onready var score_display = $ScoreDisplay
@onready var multiplier_display = $MultiplierDisplay
@onready var combo_display = $ComboDisplay
@onready var menu = $Menu
@onready var health_container = $HealthDisplay/HealthMargin/HealthContainer
@onready var player = $"../Player"
@onready var heart_png = preload("res://sprites/gui/heart.png")
@onready var health_display = $HealthDisplay


func _ready():
	combo_display.set_visible(false)
	update_health_bar()


func _input(event):
	if event.is_action_pressed('ui_cancel'):
		menu.visible = !menu.visible
		health_display.visible = !health_display.visible


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


func update_health_bar():
	print(player.health)
	for child in health_container.get_children():
		child.queue_free()
		
	if player.health > 0:
		health_container.set_columns(player.health)
		for hp in health_container.columns:
			var pc = Container.new()
			pc.custom_minimum_size = Vector2(32,32)
			health_container.add_child(pc)
			hp = TextureRect.new()
			pc.add_child(hp)
			hp.set_texture(heart_png)
			hp.scale = Vector2(3,3)


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, value < .05)


func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_ID, value < .05)
