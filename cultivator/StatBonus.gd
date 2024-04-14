extends Resource
class_name StatBonus

@export var static_base_bonus:float # added to the stat's base value before any other changes; most powerful static changes, core changes to the body
@export var percent_base_bonus:float # base percentage changes are multiplied together, then base value is multiplied by this; least powerful percentage change, ex medicines that lose effectiveness as you gain other cultivation bonuses
@export var static_flat_bonus:float # added to the stat's base value after effective base value determined; least powerful static change, ex medicines that lose effectiveness as cultivation increases
@export var percent_flat_bonus:float # effective value after previous bonuses multiplied by this; most powerful percentage change, ex powerful treasures and titles
@export var remaining_time:int # how many rounds or days the effect will linger

