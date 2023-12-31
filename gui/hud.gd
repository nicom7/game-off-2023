extends CanvasLayer

@export var skip_tutorial_visible: bool = false:
	set(value):
		skip_tutorial_visible = value
		_update_skip_tutorial()

@export var thanks_visible: bool = false:
	set(value):
		thanks_visible = value
		_update_thanks()

signal igm_pressed()
signal skip_tutorial_pressed()


func show_title() -> void:
	%Title.show()
	$AnimationPlayer.play("fade_in")
	$Timer.start()


func _ready() -> void:
	_update_skip_tutorial()


func _update_skip_tutorial() -> void:
	if is_node_ready():
		%SkipTutorialBtn.visible = skip_tutorial_visible

func _update_thanks() -> void:
	if is_node_ready():
		%ThanksLbl.visible = thanks_visible

func _on_igm_btn_pressed() -> void:
	igm_pressed.emit()


func _on_title_timer_timeout() -> void:
	$AnimationPlayer.play("fade_out")


func _on_skip_tutorial_btn_pressed() -> void:
	skip_tutorial_pressed.emit()
