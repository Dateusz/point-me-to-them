extends Resource


class_name GameOptions


const GAME_OPTIONS_PATH = "user://options.tres"

@export var music_volume: float = 1.0
@export var sfx_volume: float = 1.0
@export var camera_shake: float = 1.0


func save() -> void:
	ResourceSaver.save(self, GAME_OPTIONS_PATH)


static func load_or_create() -> GameOptions:
	var res: GameOptions = load(GAME_OPTIONS_PATH) as GameOptions
	if !res:
		res = GameOptions.new()
	return res
