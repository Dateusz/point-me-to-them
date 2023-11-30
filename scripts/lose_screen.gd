extends CanvasLayer

signal restart_game()

@onready var end_label = $Control/BoxContainer/EndLabel
@onready var open_timer = $OpenTimer
@onready var animation_player = $AnimationPlayer


func back_to_menu():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_quit_to_menu_pressed():
	back_to_menu()


func _on_game_open_lose_screen(end_message):
	open_timer.start()
	
	end_label.set_text(end_message)


func _on_open_timer_timeout():
	animation_player.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	self.visible = true
