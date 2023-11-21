extends CanvasLayer

signal igm_pressed()


func show_title() -> void:
	$Title.show()
	$AnimationPlayer.play("fade_in")
	$Timer.start()


func _on_igm_btn_pressed() -> void:
	igm_pressed.emit()


func _on_title_timer_timeout() -> void:
	$AnimationPlayer.play("fade_out")
