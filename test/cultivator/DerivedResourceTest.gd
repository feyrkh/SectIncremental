# GdUnit generated TestSuite
class_name DerivedResourceTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://cultivator/DerivedResource.gd'

var stats:Dictionary
var derived:DerivedResource

func before_test():
	stats = {
		'str': BaseStat.new(100),
		'dex': BaseStat.new(50),
		'end': BaseStat.new(120),
	}
	derived = DerivedResource.new({'str':1, 'dex':0.5, 'end':0.2}, {'dex':0.1, 'end':0.05}, stats)

func test_can_calculate_from_simple_stats():
	assert_that(derived.max_value).is_equal_approx(149, 0.00001)
	assert_that(derived.regen_value).is_equal_approx(11, 0.00001)
	assert_that(derived.value).is_equal_approx(149, 0.00001)

func test_stat_updates_affect_derived():
	assert_that(derived.max_value).is_equal_approx(149, 0.00001)
	assert_that(derived.regen_value).is_equal_approx(11, 0.00001)
	assert_that(derived.value).is_equal_approx(149, 0.00001)
	stats['dex'].base_value = 60
	assert_float(derived.max_value).is_equal_approx(154, 0.00001)
	assert_float(derived.regen_value).is_equal_approx(12, 0.00001)
	assert_float(derived.value).is_equal_approx(154, 0.00001)

func test_stat_short_bonus_affect_derived():
	assert_that(derived.max_value).is_equal_approx(149, 0.00001)
	assert_that(derived.regen_value).is_equal_approx(11, 0.00001)
	assert_that(derived.value).is_equal_approx(149, 0.00001)
	var bonus:StatBonus = StatBonus.new()
	bonus.static_base_bonus = 10000
	stats['end'].add_short_bonus('pill', bonus)
	assert_that(derived.max_value).is_equal_approx(2149, 0.00001)
	assert_that(derived.regen_value).is_equal_approx(511, 0.00001)
	assert_that(derived.value).is_equal_approx(2149, 0.00001)

func test_stat_long_bonus_affect_derived():
	assert_that(derived.max_value).is_equal_approx(149, 0.00001)
	assert_that(derived.regen_value).is_equal_approx(11, 0.00001)
	assert_that(derived.value).is_equal_approx(149, 0.00001)
	var bonus:StatBonus = StatBonus.new()
	bonus.static_base_bonus = 10000
	stats['end'].add_long_bonus('pill', bonus)
	assert_that(derived.max_value).is_equal_approx(2149, 0.00001)
	assert_that(derived.regen_value).is_equal_approx(511, 0.00001)
	assert_that(derived.value).is_equal_approx(2149, 0.00001)

func test_stat_short_bonus_can_disappear():
	assert_that(derived.max_value).is_equal_approx(149, 0.00001)
	assert_that(derived.regen_value).is_equal_approx(11, 0.00001)
	assert_that(derived.value).is_equal_approx(149, 0.00001)
	var bonus:StatBonus = StatBonus.new()
	bonus.static_base_bonus = 10000
	bonus.remaining_time = 2
	stats['end'].add_short_bonus('pill', bonus)
	assert_that(derived.max_value).is_equal_approx(2149, 0.00001)
	assert_that(derived.regen_value).is_equal_approx(511, 0.00001)
	assert_that(derived.value).is_equal_approx(2149, 0.00001)
	stats['end'].tick_short_bonuses()
	assert_that(derived.max_value).is_equal_approx(2149, 0.00001)
	assert_that(derived.regen_value).is_equal_approx(511, 0.00001)
	assert_that(derived.value).is_equal_approx(2149, 0.00001)
	stats['end'].tick_short_bonuses()
	assert_that(derived.max_value).is_equal_approx(149, 0.00001)
	assert_that(derived.regen_value).is_equal_approx(11, 0.00001)
	assert_that(derived.value).is_equal_approx(149, 0.00001)

func test_stat_long_bonus_can_disappear():
	assert_that(derived.max_value).is_equal_approx(149, 0.00001)
	assert_that(derived.regen_value).is_equal_approx(11, 0.00001)
	assert_that(derived.value).is_equal_approx(149, 0.00001)
	var bonus:StatBonus = StatBonus.new()
	bonus.static_base_bonus = 10000
	bonus.remaining_time = 2
	stats['end'].add_long_bonus('pill', bonus)
	assert_that(derived.max_value).is_equal_approx(2149, 0.00001)
	assert_that(derived.regen_value).is_equal_approx(511, 0.00001)
	assert_that(derived.value).is_equal_approx(2149, 0.00001)
	stats['end'].tick_long_bonuses()
	assert_that(derived.max_value).is_equal_approx(2149, 0.00001)
	assert_that(derived.regen_value).is_equal_approx(511, 0.00001)
	assert_that(derived.value).is_equal_approx(2149, 0.00001)
	stats['end'].tick_long_bonuses()
	assert_that(derived.max_value).is_equal_approx(149, 0.00001)
	assert_that(derived.regen_value).is_equal_approx(11, 0.00001)
	assert_that(derived.value).is_equal_approx(149, 0.00001)

func test_value_ratio_changes():
	derived.value = 100
	assert_float(derived.max_value).is_equal_approx(149, 0.00001)
	assert_float(derived.value).is_equal_approx(100, 0.00001)
	var bonus:StatBonus = StatBonus.new()
	bonus.static_base_bonus = 10000
	bonus.remaining_time = 2
	stats['end'].add_long_bonus('pill', bonus)
	assert_float(derived.max_value).is_equal_approx(2149, 0.00001)
	assert_float(derived.value).is_equal_approx(2149 * (100.0/149.0), 0.00001)
	stats['end'].tick_long_bonuses()
	stats['end'].tick_long_bonuses()
	assert_float(derived.max_value).is_equal_approx(149, 0.00001)
	assert_float(derived.value).is_equal_approx(100, 0.00001)
