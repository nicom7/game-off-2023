extends BlockSequenceTutorial

func _init_texts() -> void:
	const replay_str: = "Replay the sequence"
	_texts.append_array([
		"Press {C_note} to jump and hit the C block",
		replay_str,
		replay_str,
		replay_str,
	])
