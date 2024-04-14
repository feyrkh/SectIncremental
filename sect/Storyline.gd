extends Resource
class_name Storyline

signal entry_deleted(entry)
signal entry_added(entry)

@export var entries:Array[StoryEntry] = []

func _init() -> void:
	Calendar.date_changed.connect(update_entries)
	Events.add_story_entry.connect(new_entry)

func new_entry(name:String, desc:String, expires_in_days:int) -> void:
	var entry := StoryEntry.new(name, desc, expires_in_days)
	entries.append(entry)
	entry_added.emit(entry)

func update_entries() -> void:
	for i in range(entries.size() - 1, -1, -1):
		if entries[i].is_expired():
			entry_deleted.emit(entries[i])
			entries.remove_at(i)

