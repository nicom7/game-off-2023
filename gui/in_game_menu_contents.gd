extends VBoxContainer

signal settings_pressed()
signal help_pressed()
signal credits_pressed()
signal exit_pressed()
signal close_pressed()


func _on_settings_btn_pressed() -> void:
	settings_pressed.emit()


func _on_help_btn_pressed() -> void:
	help_pressed.emit()


func _on_credits_btn_pressed() -> void:
	credits_pressed.emit()


func _on_exit_btn_pressed() -> void:
	exit_pressed.emit()


func _on_close_menu_btn_pressed() -> void:
	close_pressed.emit()

