extends Tutorial

enum Step
{
	ACCIDENTALS_HINT,
}

var _texts: PackedStringArray = [
	"To play sharp (♯) notes, use the row above the main keys.\n{C♯_note} key is note C♯, {D♯_note} key is note D♯ and so on."
]

func _get_texts() -> PackedStringArray:
	return _texts

func _setup_texts() -> void:
	var new_texts: PackedStringArray = []
	for t in _texts:
		new_texts.append(Globals.format_input_actions(t))

	_texts = new_texts

func _ready() -> void:
	_setup_texts()

func _on_block_sequence_sequence_finished(valid) -> void:
	next_step()
