extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Calendar.date_changed.connect(on_date_changed)
	on_date_changed()

func on_date_changed()->void:
	text = "Date: "+str(Calendar.date)
