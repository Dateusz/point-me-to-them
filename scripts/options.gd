extends Control

signal set_camera_shake(value)
signal unpause()

@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var menu = $"."
@onready var music_slider = %MusicSlider
@onready var sfx_slider = %SFXSlider
@onready var cam_shake_slider = %CamShakeSlider
@onready var quit_game_button = %QuitGameButton
@onready var close_button = %CloseButton


var options: GameOptions

func _ready():
	options = GameOptions.load_or_create() 
	music_slider.value = options.music_volume
	sfx_slider.value = options.sfx_volume
	cam_shake_slider.value = options.camera_shake
	set_camera_shake.emit(cam_shake_slider.value)
	if get_tree().current_scene.name == "game":
		quit_game_button.visible = true


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, value < .05)
	if options:
		options.music_volume = value
		options.save()


func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_ID, value < .05)
	if options:
		options.sfx_volume = value
		options.save()


func _on_cam_shake_slider_value_changed(value):
	set_camera_shake.emit(value)
	options.camera_shake = value
	options.save()


func _on_close_button_pressed():
	unpause.emit()
	menu.visible = !menu.visible


func _on_quit_game_button_pressed():
	get_tree().quit()


func _on_game_open_menu():
	visible = true


func _on_game_close_menu():
	visible = false
