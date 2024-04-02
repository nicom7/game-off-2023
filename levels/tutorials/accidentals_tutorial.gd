extends Tutorial

enum Step
{
	ACCIDENTALS_HINT,
}

func _init_texts() -> void:
	_texts_web.append_array([
		"To play sharp (#) notes, use the row above the main keys.\n{C♯_note} key is note C#, {D♯_note} key is note D# and so on."
	])

	_texts.append_array(_texts_web)
	_texts[0].replace("#", "♯")

func _on_block_sequence_sequence_finished(_valid) -> void:
	next_step()
