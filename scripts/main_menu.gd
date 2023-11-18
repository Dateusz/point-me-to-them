extends Node2D


@onready var options = $CanvasLayer/Options


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_options_button_pressed():
	options.visible = !options.visible


func _on_quit_button_pressed():
	get_tree().quit()
