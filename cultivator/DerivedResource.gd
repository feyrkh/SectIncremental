extends Resource
class_name DerivedResource

signal value_updated(old_value:float, new_value:float)

@export var max_short_bonuses:Dictionary = {} #[String,StatBonus]
@export var max_long_bonuses:Dictionary = {} #[String,StatBonus]
@export var max_permanent_static_bonus:float = 0
@export var max_permanent_percent_bonus:float = 1.0

@export var regen_short_bonuses:Dictionary = {} #[String,StatBonus]
@export var regen_long_bonuses:Dictionary = {} #[String,StatBonus]
@export var regen_permanent_static_bonus:float = 0
@export var regen_permanent_percent_bonus:float = 1.0

var max_value_settings:Dictionary
var regen_settings:Dictionary
var base_stats:Dictionary 

var value:float:
	get:
		return value
	set(v):
		var old_val = value
		value = v
		if old_val != value:
			value_updated.emit(old_val, value)

var max_value:
	get:
		if max_value == null:
			max_value = calculate_max_value()
			if prev_max_value != null and abs(max_value - prev_max_value) > 0.01 and prev_max_value != 0:
				var pct_change = max_value / prev_max_value
				value *= pct_change
				value = clampf(value, 0, max_value)
		return max_value
var prev_max_value = null
var regen_value:
	get:
		if regen_value == null:
			regen_value = calculate_regen_value()
		return regen_value

func _init(max_value_settings:Dictionary, regen_settings:Dictionary, base_stats:Dictionary):
	self.max_value_settings = max_value_settings
	self.regen_settings = regen_settings
	self.base_stats = base_stats
	max_value = calculate_max_value()
	prev_max_value = max_value
	regen_value = calculate_regen_value()
	value = max_value
	connect_events()

func tick_regen():
	value = clampf(value + regen_value, 0, max_value)

func calculate_max_value():
	var base_value = 0
	for stat_name in max_value_settings:
		var base_stat:BaseStat = base_stats.get(stat_name)
		base_value += base_stat.value * max_value_settings[stat_name]
	return BaseStat.calculate_effective_value(base_value, max_permanent_static_bonus, max_permanent_percent_bonus, max_short_bonuses, max_long_bonuses)
	
func calculate_regen_value():
	var base_value = 0
	for stat_name in regen_settings:
		var base_stat:BaseStat = base_stats.get(stat_name)
		base_value += base_stat.value * regen_settings[stat_name]
	return BaseStat.calculate_effective_value(base_value, regen_permanent_static_bonus, regen_permanent_percent_bonus, regen_short_bonuses, regen_long_bonuses)

func connect_events():
	for stat_name in max_value_settings:
		var stat:BaseStat = base_stats.get(stat_name, null)
		if stat == null:
			continue
		if !stat.derived_values_need_update.is_connected(refresh):
			stat.derived_values_need_update.connect(refresh)
	for stat_name in regen_settings:
		var stat:BaseStat = base_stats.get(stat_name, null)
		if stat == null:
			continue
		if !stat.derived_values_need_update.is_connected(refresh):
			stat.derived_values_need_update.connect(refresh)

func refresh():
	if max_value != null:
		prev_max_value = max_value
	max_value = null
	regen_value = null

func describe() -> String:
	var stats = []
	var retval = 'max: '
	for k in max_value_settings:
		stats.append([k, max_value_settings[k]])
	stats.sort_custom(func(a,b): return a[1] > b[1])
	stats = stats.map(func(stat): return '%s*%d%%' % [stat[0], stat[1]*100])
	retval += ', '.join(stats)
	retval += ', regen: '
	stats = []
	for k in regen_settings:
		stats.append([k, regen_settings[k]])
	stats.sort_custom(func(a,b): return a[1] > b[1])
	stats = stats.map(func(stat): return '%s*%.1f%%' % [stat[0], stat[1]*100])
	retval += ', '.join(stats)
	return retval
