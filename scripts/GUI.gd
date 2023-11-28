extends CanvasLayer

@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")

@onready var gui = $"."
@onready var score_display = $ScoreDisplay
@onready var multiplier_display = $MultiplierDisplay
@onready var combo_display = $ComboDisplay
@onready var health_container = $HealthDisplay/HealthMargin/HealthContainer
@onready var player = $"../Player"
@onready var heart_png = preload("res://sprites/gui/heart.png")
@onready var health_display = $HealthDisplay


func _ready():
	combo_display.set_visible(false)
	update_health_bar()


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


func _on_player_health_bonus_gained():
	print("more hp!")
	update_health_bar()
