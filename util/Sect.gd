extends Node

signal cultivator_added(cultivator:Cultivator)
signal cultivator_removed(cultivator:Cultivator)
signal cultivator_selected(cultivator:Cultivator)

var cultivators:Array[Cultivator] = []
var cultivators_by_id:Dictionary = {}
var selected_cultivator:Cultivator:
	get:
		if cultivators.size() == 0:
			add_cultivator(Cultivator.random_cultivator())
			selected_cultivator = cultivators[0]
		return selected_cultivator

func set_selected_cultivator(cultivator_or_id)->void:
	if cultivator_or_id is int:
		selected_cultivator = get_cultivator(cultivator_or_id)
		cultivator_selected.emit(selected_cultivator)
	else:
		selected_cultivator = cultivator_or_id
		cultivator_selected.emit(selected_cultivator)
	print('Current cultivator set to ', selected_cultivator.char_name)

func get_cultivator(id:int) -> Cultivator:
	return cultivators_by_id.get(id)

func add_cultivator(c:Cultivator) -> void:
	cultivators.append(c)
	cultivators_by_id[c.id] = c
	Sect.cultivator_added.emit(c)

func remove_cultivator(c:Cultivator) -> void:
	cultivators_by_id.erase(c.id)
	var idx = cultivators.find(c)
	if idx >= 0:
		cultivators.remove_at(idx)
		Sect.cultivator_removed.emit(c)
