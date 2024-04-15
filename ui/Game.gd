extends PanelContainer

@onready var main_view = find_child("MainView")
@onready var right_sidebar = find_child("RightSidebar")
@onready var left_sidebar = find_child("LeftSidebar")

func _ready() -> void:
	new_game()

func new_game():
	Sect.add_cultivator(Cultivator.random_cultivator())
	Sect.add_cultivator(Cultivator.random_cultivator())
	Sect.add_cultivator(Cultivator.random_cultivator())
	Sect.add_cultivator(Cultivator.random_cultivator())
	find_child("StorylineUI").storyline = Storyline.new()
	show_panels("Storyline")
	Events.add_story_entry.emit("A band of wandering cultivators reach a secluded valley, intent on forming a new sect. The villagers of the valley welcome them hesitantly. Perhaps helping them with their troubles will lead them to warm to the new arrivals.", "", 10)


func show_panels(panel_prefix:String)->void:
	for child in left_sidebar.get_children():
		child.visible = child.name == "Global" || child.name.begins_with(panel_prefix)
		if child.visible and child.has_method("refresh"):
			child.refresh()
	for child in right_sidebar.get_children():
		child.visible = child.name == "Global" || child.name.begins_with(panel_prefix)
		if child.visible and child.has_method("refresh"):
			child.refresh()
	for child in main_view.get_children():
		child.visible = child.name == "Global" || child.name.begins_with(panel_prefix)
		if child.visible and child.has_method("refresh"):
			child.refresh()
			
func _on_new_guy_pressed() -> void:
	new_game()

func _on_storyline_btn_pressed() -> void:
	show_panels("Storyline")

func _on_cultivators_btn_pressed() -> void:
	show_panels("Cultivators")

func _on_next_date_button_pressed() -> void:
	Calendar.next_day()
