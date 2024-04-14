extends Resource
class_name CombatInstance

@export var combatant1:CombatParty
@export var combatant2:CombatParty
@export var combatant1_manual:bool = true
@export var combatant2_manual:bool = true
@export var combatant1_turn:bool = randf() < 0.5
@export var incoming_attacks:Array[TargetedAttack] = []

