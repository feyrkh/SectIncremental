extends OptionButton
class_name CultivatorDropdownSelector

signal cultivator_selected(cultivator:Cultivator)

var skip_cultivator_id:int = -1
var cur_selected:Cultivator
var filter:Callable
var sorter:Callable

func _ready() -> void:
	Sect.cultivator_added.connect(refresh_on_next_tick)
	Sect.cultivator_removed.connect(refresh_on_next_tick)
	item_selected.connect(on_item_selected)
	refresh()

func refresh_on_next_tick(c:Cultivator=null):
	set_process(true)

func _process(_delta:float) -> void:
	set_process(false)
	refresh()

func refresh():
	clear()
	selected = -1
	print('selected: ', selected)
	var cultivators = Sect.cultivators
	if filter:
		cultivators = cultivators.filter(filter)
	if sorter:
		cultivators.sort_custom(sorter)
	var saw_cur_selected:bool = false
	for cultivator in cultivators:
		if cultivator.id == skip_cultivator_id:
			continue
		add_item(cultivator.char_name)
		set_item_metadata(item_count-1, cultivator)
		print('Set item metadata for ', item_count-1, ' to ', cultivator.char_name)
		selected = item_count - 1 if cur_selected != null and (cultivator.id == cur_selected.id) else selected
	if selected < 0:
		if cultivators.size() == 0:
			cur_selected = null
		else:
			selected = 0
			print('auto-selecting first entry')
	if selected >= 0:
		cur_selected = get_item_metadata(selected)
		print('updating selected to ', cur_selected.char_name)
		cultivator_selected.emit(cur_selected)

func on_item_selected(idx:int):
	cur_selected = get_item_metadata(idx)
	print('Got item metadata for idx ', idx, ': ', cur_selected.char_name)
	cultivator_selected.emit(cur_selected)
