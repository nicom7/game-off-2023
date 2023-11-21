extends VBoxContainer

signal back_pressed()


func _on_back_btn_pressed() -> void:
	back_pressed.emit()
