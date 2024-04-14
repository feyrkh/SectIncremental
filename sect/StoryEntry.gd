extends Resource
class_name StoryEntry

@export var title:String
@export var desc:String
@export var expires:int
@export var created:int

func _init(title:String, desc:String, expires:int) -> void:
	self.created = Calendar.date
	self.title = title
	self.desc = desc
	if expires > 0:
		self.expires = Calendar.date + expires
	else:
		self.expires = -1

func is_expired() -> bool:
	return (expires > 0 && expires <= Calendar.date)
