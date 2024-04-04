extends Tutorial

enum Step
{
	CLIMB_INFO,
	CLIMB_UP_START,
	CLIMB_UP_END,
	CLIMB_DOWN_START,
	CLIMB_DOWN_END,
}

var _player_tone: Globals.Tone
var _player_on_floor: bool = false


func _init_texts() -> void:
	_texts.append_array([
		"To climb up or down a platform, play the corresponding note\nfor the platform you want to reach.",
		"Move near the stairs and play the E note on\nthe keyboard ({E_note} key) to climb up",
		"Hold {E_note} to reach the E platform",
		"Play the C note on the keyboard ({C_note} key) to climb down",
		"Hold {C_note} to reach the C platform",
	])


func _on_player_current_tone_changed(tone) -> void:
	_player_tone = tone


func _on_player_direction_changed(direction) -> void:
	match _step:
		Step.CLIMB_UP_START:
			if direction.y < 0:
				next_step()
		Step.CLIMB_DOWN_START:
			if direction.y > 0:
				next_step()


func _on_player_on_floor_changed(value) -> void:
	_player_on_floor = value
	match _step:
		Step.CLIMB_UP_END:
			if _player_tone == Globals.Tone.E and _player_on_floor:
				next_step()
		Step.CLIMB_DOWN_END:
			if _player_tone == Globals.Tone.C and _player_on_floor:
				next_step()


func _on_timer_timeout() -> void:
	next_step()


func _on_step_changed(step: int) -> void:
	match step:
		Step.CLIMB_INFO:
			$Timer.start()
