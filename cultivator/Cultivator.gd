extends Resource
class_name Cultivator

static var next_cultivator_id:int = 1

static var ONE_CONST := BaseStat.new(1)

const BASE_STATS = [
	"str", "end", "vit", "dex", "int", "wis", "will", "luck"
]

const DERIVED_RESOURCES:Array[String] = [
	'time', 'hp', 'sp', 'balance', 'reaction', 'speed'
]

const DERIVED_RESOURCES_DATA:Dictionary = { # first set generates 'max', second is regeneration rate
	"hp": [{"str": 0.1, "vit": 0.7, "end": 0.2}, {"vit": 0.09, "end": 0.01}],
	"sp": [{"end": 0.7, "str": 0.2, "will": 0.1}, {"end":0.5/3, "vit": 0.1/3, "will": 0.4/3}],
	"balance": [{"end": 0.5, "dex": 0.3, "int": 0.2}, {"dex": 30}],
	"reaction": [{"dex": 0.8, "will": 0.1, "wis": 0.1}, {"int": 10, "dex": 10}],
	"speed": [{"dex": 0.5, "end": 0.2, "str": 0.1}, {"end": 10, "dex": 10}],
	"time": [{"1": 10}, {"1": 100000}]
}

@export var id:int
@export var char_name:String:
	set(v):
		char_name = v
		changed.emit()

@export var base_stats:Dictionary = {'1':ONE_CONST} # [String, BaseStat]
@export var derived_resources:Dictionary = {} # [String, DerivedResource]

var health:DerivedResource:
	get:
		return derived_resources.get('hp')

var stamina:DerivedResource:
	get:
		return derived_resources.get('sp')

static func random_cultivator() -> Cultivator:
	var new_guy = Cultivator.new()
	new_guy.char_name = "Wandering Cultivator #" + str(next_cultivator_id)
	new_guy.id = next_cultivator_id
	next_cultivator_id += 1
	for stat in BASE_STATS:
		new_guy.base_stats[stat] = BaseStat.new(randfn(100, 20))
	for resource in DERIVED_RESOURCES:
		new_guy.derived_resources[resource] = DerivedResource.new(DERIVED_RESOURCES_DATA[resource][0], DERIVED_RESOURCES_DATA[resource][1], new_guy.base_stats)
	return new_guy

func _init():
	Calendar.day_passed.connect(tick_long_bonuses)

func tick_short_bonuses() -> void:
	for stat_name in BASE_STATS:
		base_stats[stat_name].tick_short_bonuses()

func tick_long_bonuses() -> void:
	for stat_name in BASE_STATS:
		base_stats[stat_name].tick_long_bonuses()
