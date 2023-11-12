@tool
extends Node

class_name SoundQueue

@export var count: int

var _next = 0
var _audio_stream_players: Array

func _ready():
	if get_child_count() == 0:
		print("No AudioStreamPlayer child found")
		return
		
	var child = get_child(0)
	
	if child is AudioStreamPlayer2D:
		_audio_stream_players.append(child)
		
		for i in range(0, count, 1):
			var duplicate = child.duplicate() as AudioStreamPlayer2D
			add_child(duplicate)
			_audio_stream_players.append(duplicate)


func _get_configuration_warnings():
	if get_child_count() == 0:
		return ["No children found. Expected one AudioStreamPlayer2D child."]
	
	if !is_instance_of(get_child(0), AudioStreamPlayer2D):
		return ["Expected first child to be AudioStreamPlayer2D."]
	
	return _get_configuration_warnings()


func play_sound():
	if !_audio_stream_players[_next].playing:
		_audio_stream_players[_next+1].play()
		_next %= _audio_stream_players.size()
