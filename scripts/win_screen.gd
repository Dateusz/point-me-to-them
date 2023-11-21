extends CanvasLayer

signal hide_ui()
signal show_ui()
signal add_skill(skill)

@export var skill_choice_scene: PackedScene

@onready var win_screen = $WinScreenCanvas
@onready var open_timer = $OpenTimer
@onready var close_timer = $CloseTimer
@onready var intermediate_text = $WinScreenCanvas/Control/IntermediateText
@onready var skill_pool = $SkillPool
@onready var skills_display = $WinScreenCanvas/Control/SkillChoose/Skills


var selected_skills: Array


func _ready():
	intermediate_text.text = "[center]SELECT A SKILL
TO CONTINUE[/center]"

	show_skill_selection()


func _on_skill_icon_pressed(skill):
	add_skill.emit(skill)
	close_timer.start()


func _on_game_open_win_screen():
	open_timer.start()


func _on_open_timer_timeout():
	win_screen.visible = !win_screen.visible
	hide_ui.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_close_timer_timeout():
	show_ui.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func show_skill_selection():
	selected_skills = skill_pool.get_random_skills()
	
	for skill in selected_skills:
		var sc = skill_choice_scene.instantiate()
		sc.skill = skill
		sc.connect("chosen", skill_chosen)
		skills_display.add_child(sc)
		

func skill_chosen(skill):
	print("FUCK YOOUUUUUUUUUUUUUUUU BIIIIIIIIITCH")
