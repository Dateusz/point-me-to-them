@tool
extends Node

@onready var skeleton_hit_sound_pool = $SkeletonHitSoundPool
@onready var player_hit_sound_queue = $PlayerHitSoundQueue


var _sound_queues_by_name = {}
var _sound_pools_by_name = {}

func _ready():
	_sound_pools_by_name["SkeletonHitSoundPool"] = skeleton_hit_sound_pool
	_sound_queues_by_name["PlayerHitSoundQueue"] = player_hit_sound_queue

func play_skeleton_hit_sound():
	_sound_pools_by_name["SkeletonHitSoundPool"].play_random_sound()

func play_player_hit_sound():
	_sound_queues_by_name["PlayerHitSoundQueue"].play_sound()
