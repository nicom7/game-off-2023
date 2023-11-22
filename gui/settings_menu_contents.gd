extends VBoxContainer

signal back_pressed()

func _ready() -> void:
	%AmbientVolSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Ambient")))
	%SFXVolSlider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))

func _on_back_btn_pressed() -> void:
	back_pressed.emit()


func _on_ambient_vol_slider_drag_started() -> void:
	%AmbientNotePlayer.start()


func _on_ambient_vol_slider_drag_ended(_value_changed: bool) -> void:
	%AmbientNotePlayer.stop()


func _on_ambient_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ambient"), linear_to_db(value))


func _on_sfx_vol_slider_drag_ended(_value_changed: bool) -> void:
	%SFXNotePlayer.start()


func _on_sfx_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
