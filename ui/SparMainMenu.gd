extends ScrollContainer

@onready var cultivator_selector:CultivatorDropdownSelector = find_child('CultivatorSelect')
@onready var notes:Label = find_child("Notes")
@onready var start_button:Button = find_child("StartSparButton")

func _ready() -> void:
	cultivator_selector.skip_cultivator_id = Sect.selected_cultivator.id
	Sect.cultivator_selected.connect(func(new_selected): 
		if new_selected == null: 
			refresh_notes()
			return
		cultivator_selector.skip_cultivator_id = Sect.selected_cultivator.id
		cultivator_selector.refresh_on_next_tick()
		refresh_notes()
	)
	cultivator_selector.cultivator_selected.connect(func(new_selected): refresh_notes())
	start_button.pressed.connect(start_spar)
	Calendar.date_changed.connect(refresh_on_next_tick)

func refresh_on_next_tick():
	set_process(true)

func _process(_delta:float) -> void:
	set_process(false)
	refresh_notes()

func refresh_notes():
	var c1 := Sect.selected_cultivator
	var c2 := cultivator_selector.cur_selected
	if c1 == null or c2 == null:
		notes.text = 'Must have two cultivators to spar'
		start_button.disabled = true
		return
	if c1.time.value <= 0 or c2.time.value <= 0:
		notes.text = 'Both cultivators must have time remaining today'
		start_button.disabled = true
		return
	notes.text = 'Begin sparring'
	start_button.disabled = false

func start_spar():
	var c1 := Sect.selected_cultivator
	var c2 := cultivator_selector.cur_selected
	c1.time.value -= 1
	c2.time.value -= 1
	refresh_notes()
	
