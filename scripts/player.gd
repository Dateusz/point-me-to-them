extends Node2D

@onready var player = $CharacterBody2D
var cursor = preload("res://sprites/cursor.png")

func _ready():
	pass


func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position)
	elif event is InputEventMouseMotion:
		player.position = event.position
