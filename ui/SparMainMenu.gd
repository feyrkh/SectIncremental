extends ScrollContainer

@onready var cultivator_selector:CultivatorDropdownSelector = find_child('CultivatorSelect')

func _ready() -> void:
	cultivator_selector.skip_cultivator_id = Sect.selected_cultivator.id
	Sect.cultivator_selected.connect(func(new_selected): 
		if new_selected == null: return
		cultivator_selector.skip_cultivator_id = Sect.selected_cultivator.id
		cultivator_selector.refresh_on_next_tick()
	)
