extends ScrollContainer
class_name CultivatorButtonSelector

signal cultivator_selected(cultivator:Cultivator)

@onready var cultivator_list:Control = find_child("CultivatorList")

var skip_cultivator_id:int = -1
var cur_selected:Cultivator
var filter:Callable
var sorter:Callable
var button_group:ButtonGroup = ButtonGroup.new()

func _ready() -> void:
	Sect.cultivator_added.connect(refresh_on_next_tick)
	Sect.cultivator_removed.connect(refresh_on_next_tick)
	button_group.pressed.connect(button_pressed)
	button_group.allow_unpress
	refresh_on_next_tick()

func refresh_on_next_tick(c:Cultivator=null):
	set_process(true)

func _process(_delta:float) -> void:
	set_process(false)
	refresh()

func refresh():
	for child in cultivator_list.get_children():
		child.queue_free()
	var cultivators = Sect.cultivators
	if filter:
		cultivators = cultivators.filter(filter)
	if sorter:
		cultivators.sort_custom(sorter)
	var saw_cur_selected:bool = false
	for cultivator in cultivators:
		if cultivator.id == skip_cultivator_id:
			continue
		var btn = Button.new()
		btn.set_meta('cultivator', cultivator)
		btn.button_group = button_group;
		btn.text = cultivator.char_name
		btn.toggle_mode = true
		btn.button_pressed = cur_selected != null and (cultivator.id == cur_selected.id)
		if cultivator == cur_selected:
			saw_cur_selected = true
		cultivator_list.add_child(btn)
	if !saw_cur_selected:
		cur_selected = null

func button_pressed(button:BaseButton):
	cur_selected = button.get_meta('cultivator')
	cultivator_selected.emit(cur_selected)
