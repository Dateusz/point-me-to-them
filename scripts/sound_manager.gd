@tool
extends Node

@onready var skeleton_hit_sound_pool = $SkeletonHitSoundPool

var _sound_queues_by_name = {}
var _sound_pools_by_name = {}

func _ready():
	_sound_pools_by_name["SkeletonHitSoundPool"] = skeleton_hit_sound_pool
	

func play_skeleton_hit_sound():
	_sound_pools_by_name["SkeletonHitSoundPool"].play_random_sound()

