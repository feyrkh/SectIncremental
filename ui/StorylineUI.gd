extends PanelContainer
class_name StorylineUI

var storyline:Storyline:
	set(v):
		if storyline:
			storyline.entry_added.disconnect(on_entry_added)
			storyline.entry_deleted.disconnect(on_entry_deleted)
		storyline = v
		if storyline:
			storyline.entry_added.connect(on_entry_added)
			storyline.entry_deleted.connect(on_entry_deleted)

func _ready():
	refresh()

func refresh()->void:
	for child in get_children():
		child.queue_free()
	if storyline == null:
		return
	for entry in storyline.entries:
		on_entry_added(entry)
	
func on_entry_added(entry:StoryEntry):
	var ui = preload("res://ui/StoryEntryUI.tscn").instantiate()
	ui.story_entry = entry
	add_child(ui)
	move_child(ui, 0)

func on_entry_deleted(entry:StoryEntry):
	for child in get_children():
		if child.story_entry == entry:
			child.queue_free()
			break
