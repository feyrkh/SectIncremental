extends VBoxContainer
class_name CultivatorInfo

signal cultivator_selected(cultivator:Cultivator)

@onready var cultivator_select:CultivatorDropdownSelector = find_child('CultivatorSelect')
@onready var stats_container:GridContainer = find_child('StatsContainer')

func _ready() -> void:
	#populate_cultivator_select()
	cultivator_select.cultivator_selected.connect(on_cultivator_selected)
	refresh()

func refresh() -> void:
	for child in stats_container.get_children():
		child.queue_free()
	#CharName.text = selected_cultivator.char_name
	if cultivator_select.cur_selected == null:
		var label = Label.new()
		label.text = 'No cultivator selected'
		stats_container.add_child(label)
		return
	for stat_name in Cultivator.DERIVED_RESOURCES:
		var name_label = Label.new()
		name_label.text = stat_name
		stats_container.add_child(name_label)
		var stat = cultivator_select.cur_selected.derived_resources.get(stat_name)
		var info_label = Label.new()
		info_label.text = '%d/%d' % [stat.value, stat.max_value]
		stats_container.add_child(info_label)
	for stat_name in Cultivator.BASE_STATS:
		var name_label = Label.new()
		name_label.text = stat_name
		stats_container.add_child(name_label)
		var stat:BaseStat = cultivator_select.cur_selected.base_stats.get(stat_name)
		var info_label = Label.new()
		info_label.text = '%d' % [stat.value]
		stats_container.add_child(info_label)
		
		
	#CharHp.text = '%d/%d health' % [ceil(Sect.selected_cultivator.health.value), ceil(Sect.selected_cultivator.health.max_value)]
	#CharHp.tooltip_text = Sect.selected_cultivator.health.describe()
	#CharSp.text = '%d/%d stamina' % [ceil(Sect.selected_cultivator.stamina.value), ceil(Sect.selected_cultivator.stamina.max_value)]
	#CharHp.tooltip_text = Sect.selected_cultivator.stamina.describe()
	
func on_cultivator_selected(cultivator:Cultivator) -> void:
	refresh()
	cultivator_selected.emit(cultivator)

