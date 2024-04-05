extends VBoxContainer

signal back_pressed()


func _open_url(url: String) -> void:
	if url:
		OS.shell_open(url)

func _on_back_btn_pressed() -> void:
	back_pressed.emit()


func _on_label_meta_clicked(meta: Variant) -> void:
	_open_url(meta as String)


func _on_surge_xt_lbl_meta_clicked(meta: Variant) -> void:
	_open_url(meta as String)


func _on_credits_info_lbl_meta_clicked(meta: Variant) -> void:
	_open_url(meta as String)
