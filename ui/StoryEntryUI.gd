extends HBoxContainer
class_name StoryEntryUI

@onready var short_desc:Label = find_child("ShortDesc")
@onready var date_info:Label = find_child("DateInfo")

var story_entry:StoryEntry:
	set(v):
		story_entry = v
		if short_desc != null and is_instance_valid(short_desc):
			refresh()

func _ready():
	refresh()
	Calendar.date_changed.connect(refresh)

func refresh():
	short_desc.text = story_entry.title
	if story_entry.expires > 0:
		date_info.text = "(%s, expires: %dd)" % [date_offset_str(story_entry.created), story_entry.expires - Calendar.date]
	else:
		date_info.text = "(%s)" % [date_offset_str(story_entry.created)]

func date_offset_str(created_date:int)->String:
	if created_date == Calendar.date:
		return 'today'
	var date_diff = Calendar.date - created_date
	if date_diff == 1:
		return '1 day ago'
	else:
		return str(date_diff)+' days ago'
