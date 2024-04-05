extends Tutorial

enum Step
{
	C_SCALE_INFO,
	KEYBOARD_INFO,
	MOVE_TO_C,
	JUMP_C,
	TOGGLE_TONE_LABELS,
	MOVE_TO_D,
	JUMP_D,
}

var _player_tone: Globals.Tone
var _player_on_floor: bool = false


func _init_texts() -> void:
	_texts.append_array([
		"The seven notes of the C major scale are\nC, D, E, F, G, A, B",
		"In this game, we will use the keyboard like a piano\nto play music notes and jump or climb on platforms",
		"Use the arrow keys (← or →) to move to the C platform",
		"While on the C platform, play the C note on the keyboard ({C_note} key) to jump",
		"You can also press {toggle_tone_labels} to toggle between key\nand note overlays on the platforms and blocks",
		"Use the arrow keys (← or →) to move to the D platform",
		"While on the D platform, play the D note on the keyboard ({D_note} key) to jump",
	])

	_texts_web = _texts.duplicate()
	for i in [Step.MOVE_TO_C, Step.MOVE_TO_D]:
		_texts_web[i] = _texts_web[i].replace("arrow keys (← or →)", "left or right arrow keys")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_tone_labels"):
		match _step:
			Step.TOGGLE_TONE_LABELS:
				#next_step()
				pass

func _on_player_jumped(_notes: int) -> void:
	var notes_list = Globals.get_notes_from_bitfield(_notes)
	if notes_list.size() != 1:
		return

	match _step:
		Step.JUMP_C:
			if notes_list[0] == Globals.Tone.C:
				next_step()
		Step.JUMP_D:
			if notes_list[0] == Globals.Tone.D:
				next_step()


func _on_player_current_tone_changed(tone) -> void:
	_player_tone = tone
	match _step:
		Step.MOVE_TO_C:
			if _player_tone == Globals.Tone.C:
				next_step()
		Step.JUMP_C:
			if _player_tone != Globals.Tone.C:
				set_step(Step.MOVE_TO_C)
		Step.MOVE_TO_D:
			if _player_tone == Globals.Tone.D:
				next_step()
		Step.JUMP_D:
			if _player_tone != Globals.Tone.D:
				set_step(Step.MOVE_TO_D)


func _on_player_on_floor_changed(value) -> void:
	_player_on_floor = value


func _on_timer_timeout() -> void:
	match _step:
		Step.C_SCALE_INFO:
			next_step()
		Step.KEYBOARD_INFO:
			next_step()
			if _player_tone == Globals.Tone.C:
				# Skip move to C step if already on C platform
				next_step()
		Step.TOGGLE_TONE_LABELS:
			next_step()
			if _player_tone == Globals.Tone.D:
				# Skip move to D step if already on D platform
				next_step()


func _on_step_changed(step: int) -> void:
	match step:
		Step.C_SCALE_INFO, Step.KEYBOARD_INFO, Step.TOGGLE_TONE_LABELS:
			$Timer.start()
