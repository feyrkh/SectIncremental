extends PanelContainer

@onready var cultivator_selector:CultivatorInfo = find_child("CultivatorInfo")

func _ready():
	cultivator_selector.cultivator_selected.connect(on_current_cultivator_changed)

func on_current_cultivator_changed(cultivator:Cultivator):
	Sect.set_selected_cultivator(cultivator)
