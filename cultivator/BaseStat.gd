extends Resource
class_name BaseStat

signal effective_value_changed(old_value:float, new_value:float)
signal derived_values_need_update()

@export var base_value:float = 100:
	set(v):
		base_value = v
		if _effective_value != null:
			previous_effective_value = _effective_value
		_effective_value = null
@export var short_bonuses:Dictionary = {} #[String,StatBonus]
@export var long_bonuses:Dictionary = {} #[String,StatBonus]
@export var permanent_static_bonus:float = 0:
	set(v):
		permanent_static_bonus = v
		if _effective_value != null:
			previous_effective_value = _effective_value
		_effective_value = null
@export var permanent_percent_bonus:float = 1.0:
	set(v):
		permanent_percent_bonus = v
		if _effective_value != null:
			previous_effective_value = _effective_value
		_effective_value = null

var _effective_value = null:
	set(v):
		if !v == _effective_value:
			_effective_value = v
			derived_values_need_update.emit()
var value:
	set(v):
		if !_effective_value == v:
			_effective_value = v
	get:
		if _effective_value == null:
			update_effective_value()
			if previous_effective_value != null && abs(previous_effective_value - _effective_value) > 0.01:
				effective_value_changed.emit(previous_effective_value, _effective_value)
		return _effective_value
var previous_effective_value

func _init(base_value:float):
	self.base_value = base_value
	self.previous_effective_value = base_value

static func calculate_effective_value(base_value, permanent_static_bonus, permanent_percent_bonus, short_bonuses, long_bonuses) -> float:
	var v = (base_value + permanent_static_bonus) * permanent_percent_bonus
	var base_static:float = 0
	var base_pct:float = 1.0
	var flat_static:float = 0
	var flat_pct:float = 1.0
	for bonus_name in long_bonuses:
		var bonus:StatBonus = long_bonuses[bonus_name]
		base_static += bonus.static_base_bonus
		flat_static += bonus.static_flat_bonus
		if bonus.percent_base_bonus != 0:
			base_pct *= bonus.percent_base_bonus
		if bonus.percent_flat_bonus != 0:
			flat_pct *= bonus.percent_flat_bonus
	for bonus_name in short_bonuses:
		var bonus:StatBonus = short_bonuses[bonus_name]
		base_static += bonus.static_base_bonus
		flat_static += bonus.static_flat_bonus
		if bonus.percent_base_bonus != 0:
			base_pct *= bonus.percent_base_bonus
		if bonus.percent_flat_bonus != 0:
			flat_pct *= bonus.percent_flat_bonus
	return ((v + base_static) * base_pct) * flat_pct + flat_static

func update_effective_value() -> void:
	value = calculate_effective_value(base_value, permanent_static_bonus, permanent_percent_bonus, short_bonuses, long_bonuses)

func add_short_bonus(source:String, bonus:StatBonus):
	if _effective_value != null:
		previous_effective_value = _effective_value
	short_bonuses[source] = bonus
	_effective_value = null

func add_long_bonus(source:String, bonus:StatBonus):
	if _effective_value != null:
		previous_effective_value = _effective_value
	long_bonuses[source] = bonus
	_effective_value = null

func tick_short_bonuses():
	for bonus_name in short_bonuses.keys():
		var bonus:StatBonus = short_bonuses.get(bonus_name)
		bonus.remaining_time -= 1
		if bonus.remaining_time <= 0:
			short_bonuses.erase(bonus_name)
			_effective_value = null

func tick_long_bonuses():
	if short_bonuses.size() > 0:
		short_bonuses.clear()
		_effective_value = null
	for bonus_name in long_bonuses.keys():
		var bonus:StatBonus = long_bonuses.get(bonus_name)
		bonus.remaining_time -= 1
		if bonus.remaining_time <= 0:
			long_bonuses.erase(bonus_name)
			_effective_value = null

