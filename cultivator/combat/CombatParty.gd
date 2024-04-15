extends Resource
class_name CombatParty

@export var cultivator_ids:Array[int] = []
@export var npc_ids:Array[int] = []

func is_cultivator_in_party(cultivator:Cultivator):
	return cultivator_ids.find(cultivator.id) >= 0
