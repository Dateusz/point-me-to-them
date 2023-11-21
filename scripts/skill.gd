extends Node

class_name Skill

@export var skill: Resource
@onready var normal_texture: CompressedTexture2D = skill.normal_texture
@onready var pressed_texture: CompressedTexture2D = skill.pressed_texture
@onready var hover_texture: CompressedTexture2D = skill.hover_texture
@onready var skill_name: String = skill.skill_name
@onready var description: String = skill.description
