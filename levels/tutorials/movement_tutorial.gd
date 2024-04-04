extends Tutorial

enum Step
{
	MOVE,
}

var _player_tone: Globals.Tone
var _player_on_floor: bool = false

func _init_texts() -> void:
	_texts.append("Hold → or ← to move")
	_texts_web.append("Hold left or right arrow to move")

func _on_player_jumped(_notes: int) -> void:
	pass


func _on_player_current_tone_changed(tone) -> void:
	_player_tone = tone


func _on_player_direction_changed(direction) -> void:
	match _step:
		Step.MOVE:
			if direction.x:
				next_step()


func _on_player_on_floor_changed(value) -> void:
	_player_on_floor = value
