extends Node

signal date_changed()
signal day_passed()

var date:int = 0:
	set(v):
		date = v
		date_changed.emit()

func next_day():
	date += 1
	day_passed.emit()
