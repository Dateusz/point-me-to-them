extends CanvasLayer

signal restart_game()

@onready var end_label = $Control/BoxContainer/EndLabel


func back_to_menu():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_quit_to_menu_pressed():
	back_to_menu()


func _on_game_open_lose_screen(end_message):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	end_label.set_text(end_message)
	self.visible = true
