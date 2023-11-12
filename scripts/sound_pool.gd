@tool
extends Node

class_name SoundPool

@onready var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

var _sounds: Array
var _last_index = -1;

func _ready():
	for child in get_children():
		_sounds.append(child)


func play_random_sound():
	var index = _rng.randi_range(0, _sounds.size() - 1)
	
	while true:
		
		index = _rng.randi_range(0, _sounds.size() - 1)
		
		if index != _last_index:
			break
	
	_last_index = index
	_sounds[index].play_sound()


func _get_configuration_warnings():
	
	var sq_children = 0
	for child in get_children():
		if child is SoundQueue:
			sq_children += 1
	
	if sq_children < 2:
		return ["Two or more children of type SoundQueue expected"]
	
	return _get_configuration_warnings()
