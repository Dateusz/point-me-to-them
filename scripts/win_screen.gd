extends CanvasLayer

signal hide_ui()
signal show_ui()
signal next_round()
signal add_skill()

@export var skill_choice_scene: PackedScene

@onready var win_screen = $WinScreenCanvas
@onready var open_timer = $OpenTimer
@onready var close_timer = $CloseTimer
@onready var intermediate_text = $WinScreenCanvas/Control/IntermediateText
@onready var skill_pool = $SkillPool
@onready var skills_display = $WinScreenCanvas/Control/SkillChoose/Skills
@onready var animation_player = $AnimationPlayer


var selected_skills: Array


func _ready():
	pass


func _on_game_open_win_screen():
	open_timer.start()
	intermediate_text.text = str("[center]SELECT A SKILL ", 
									"TO CONTINUE[/center]")


func _on_open_timer_timeout():
	animation_player.set_assigned_animation("open")
	animation_player.play()
	open_timer.stop()
	show_skill_selection()
	hide_ui.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_close_timer_timeout():
	animation_player.set_assigned_animation("close")
	animation_player.play()
	show_ui.emit()
	next_round.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func show_skill_selection():
	selected_skills = skill_pool.get_random_skills()
	
	for skill in selected_skills:
		var sc = skill_choice_scene.instantiate()
		sc.skill = skill
		sc.connect("chosen", skill_chosen)
		skills_display.add_child(sc)
		

func skill_chosen(skill):
	add_skill.emit(skill)
	close_timer.start()
	for child in skills_display.get_children():
		child.queue_free()
