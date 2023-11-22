extends Node

class_name SkillPool

@onready var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

var _skill_pool: Array


func _ready():
	for child in get_children():
		_skill_pool.append(child)


func get_random_skills():
	var available_skills = _skill_pool.size()
	
	if available_skills == 0:
		return []
		
	var skills_to_pick = min(3, available_skills)
	
	var selected_skills: Array = []
	
	for _i in range(skills_to_pick):
		
		var rand_index = _rng.randi_range(0, available_skills - 1)
		selected_skills.append(_skill_pool[rand_index])
		_skill_pool.remove_at(rand_index)
		available_skills -= 1
		
	_skill_pool += selected_skills
	return selected_skills


