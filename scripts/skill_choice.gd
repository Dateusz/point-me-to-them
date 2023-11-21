extends VBoxContainer

signal chosen(skill)

@onready var skill_choice = $"."
@onready var skill_name_label = $SkillName
@onready var skill_button = $SkillButton
@onready var skill_desc_label = $SkillDesc

@export var skill: Node


func _ready():
	render_skill_choice()


func render_skill_choice():	
	skill_name_label.set_text(
		str("[center]", skill.skill_name, "[/center]")
		)
	
	skill_button.set_texture_normal(skill.normal_texture)
	skill_button.set_texture_pressed(skill.pressed_texture)
	skill_button.set_texture_hover(skill.hover_texture)
	skill_button.set_toggle_mode(true)
	
	skill_desc_label.set_text(
		str("[center]", skill.description, "[/center]")
		)


func _on_skill_button_pressed():
	chosen.emit(skill)

