# GdUnit generated TestSuite
class_name BaseStatTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://cultivator/BaseStat.gd'

var signaled_old_value = null
var signaled_new_value = null
var stat:BaseStat

func before_test():
	signaled_old_value = null
	signaled_new_value = null
	stat = BaseStat.new(100)
	stat.value_updated.connect(
		func(old_val, new_val): 
			signaled_old_value = old_val
			signaled_new_value = new_val
	)

func assert_value_change(old_val, new_val):
	assert_float(stat.effective_value).is_equal_approx(new_val, 0.000001)
	assert_float(signaled_old_value).is_equal_approx(old_val, 0.000001)
	assert_float(signaled_new_value).is_equal_approx(new_val, 0.000001)

func test_calculate_effective_value() -> void:
	assert_that(stat.effective_value).is_equal(100)

func test_value_change_causes_signal() -> void:
	stat.base_value = 10
	assert_value_change(100, 10)
	stat.base_value = 139.5
	assert_value_change(10, 139.5)
	stat.base_value = 1
	stat.base_value = 2
	assert_value_change(139.5, 2)

func test_permanent_static_bonus() -> void:
	stat.permanent_static_bonus = -10
	assert_value_change(100, 90)
	
func test_permanent_percent_bonus() -> void:
	stat.permanent_percent_bonus = 0.85
	assert_value_change(100, 85)
	
func test_permanent_dual_bonus() -> void:
	stat.permanent_static_bonus = 50
	stat.permanent_percent_bonus = 1.10
	assert_value_change(100, 165)

func test_short_bonus() -> void:
	var bonus:StatBonus = StatBonus.new()
	bonus.static_base_bonus = 1
	bonus.static_flat_bonus = 15
	bonus.percent_base_bonus = 2.0
	bonus.percent_flat_bonus = 0.7
	# base 100, +1, *2, *0.7, +15 = 156.4
	stat.add_short_bonus('pill', bonus)
	assert_value_change(100.0, 156.4)

func test_long_bonus() -> void:
	var bonus:StatBonus = StatBonus.new()
	bonus.static_base_bonus = 1
	bonus.static_flat_bonus = 15
	bonus.percent_base_bonus = 2.0
	bonus.percent_flat_bonus = 0.7
	# base 100, +1, *2, *0.7, +15 = 156.4
	stat.add_long_bonus('pill', bonus)
	assert_value_change(100.0, 156.4)

func test_dual_bonus1() -> void:
	var short_bonus:StatBonus = StatBonus.new()
	var long_bonus:StatBonus = StatBonus.new()
	short_bonus.static_base_bonus = 1
	short_bonus.static_flat_bonus = 15
	long_bonus.percent_base_bonus = 2.0
	long_bonus.percent_flat_bonus = 0.7
	# base 100, +1, *2, *0.7, +15 = 156.4
	stat.add_short_bonus('pill', short_bonus)
	stat.add_long_bonus('pill', long_bonus)
	assert_value_change(100.0, 156.4)

func test_dual_bonus2() -> void:
	var short_bonus:StatBonus = StatBonus.new()
	var long_bonus:StatBonus = StatBonus.new()
	long_bonus.static_base_bonus = 1
	long_bonus.static_flat_bonus = 15
	short_bonus.percent_base_bonus = 2.0
	short_bonus.percent_flat_bonus = 0.7
	# base 100, +1, *2, *0.7, +15 = 156.4
	stat.add_short_bonus('pill', short_bonus)
	stat.add_long_bonus('pill', long_bonus)
	assert_value_change(100.0, 156.4)

func test_dual_bonus3() -> void:
	var bonus1:StatBonus = StatBonus.new()
	var bonus2:StatBonus = StatBonus.new()
	bonus1.static_base_bonus = 1
	bonus2.static_flat_bonus = 15
	bonus1.percent_base_bonus = 2.0
	bonus2.percent_flat_bonus = 0.7
	# base 100, +1, *2, *0.7, +15 = 156.4
	stat.add_short_bonus('pill1', bonus1)
	stat.add_short_bonus('pill2', bonus2)
	assert_value_change(100.0, 156.4)

func test_dual_bonus4() -> void:
	var bonus1:StatBonus = StatBonus.new()
	var bonus2:StatBonus = StatBonus.new()
	bonus1.static_base_bonus = 1
	bonus2.static_flat_bonus = 15
	bonus1.percent_base_bonus = 2.0
	bonus2.percent_flat_bonus = 0.7
	# base 100, +1, *2, *0.7, +15 = 156.4
	stat.add_long_bonus('pill1', bonus1)
	stat.add_long_bonus('pill2', bonus2)
	assert_value_change(100.0, 156.4)

func test_dual_bonus5() -> void:
	var bonus1:StatBonus = StatBonus.new()
	var bonus2:StatBonus = StatBonus.new()
	bonus1.static_base_bonus = 1
	bonus1.static_flat_bonus = 15
	bonus1.percent_base_bonus = 2.0
	bonus1.percent_flat_bonus = 0.7
	bonus2.static_base_bonus = 1
	bonus2.static_flat_bonus = 15
	bonus2.percent_base_bonus = 2.0
	bonus2.percent_flat_bonus = 0.7
	# base 100, +1+1, *2*2, *0.7*0.7, +15+15 = 
	stat.add_short_bonus('pill1', bonus1)
	stat.add_short_bonus('pill2', bonus2)
	assert_value_change(100.0, 229.92)

func test_dual_bonus6() -> void:
	var bonus1:StatBonus = StatBonus.new()
	var bonus2:StatBonus = StatBonus.new()
	bonus1.static_base_bonus = 1
	bonus1.static_flat_bonus = 15
	bonus1.percent_base_bonus = 2.0
	bonus1.percent_flat_bonus = 0.7
	bonus2.static_base_bonus = 1
	bonus2.static_flat_bonus = 15
	bonus2.percent_base_bonus = 2.0
	bonus2.percent_flat_bonus = 0.7
	# base 100, +1+1, *2*2, *0.7*0.7, +15+15 = 
	stat.add_long_bonus('pill1', bonus1)
	stat.add_long_bonus('pill2', bonus2)
	assert_value_change(100.0, 229.92)
