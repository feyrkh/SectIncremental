extends VBoxContainer

func _on_spar_button_pressed() -> void:
	for child in get_children():
		child.visible = false
	find_child("SparMain").visible = true
	
