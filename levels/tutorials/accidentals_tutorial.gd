extends Tutorial

enum Step
{
	ACCIDENTALS_HINT,
}

var _texts: PackedStringArray = [
	"To play sharp (♯) notes, use the row above the main keys.\n{C♯_note} key is note C♯, {D♯_note} key is note D♯ and so on."
]

var _texts_web: PackedStringArray = [
	"To play sharp (#) notes, use the row above the main keys.\n{C♯_note} key is note C#, {D♯_note} key is note D# and so on."
]

func _get_texts() -> PackedStringArray:
	return _texts_web if OS.has_feature("web") else _texts

func _setup_texts() -> void:
	var new_texts: PackedStringArray = []
	for t in _texts:
		new_texts.append(Globals.format_input_actions(t))

	_texts = new_texts.duplicate()

	new_texts.clear()
	for t in _texts_web:
		new_texts.append(Globals.format_input_actions(t))

	_texts_web = new_texts.duplicate()

func _ready() -> void:
	_setup_texts()

func _on_block_sequence_sequence_finished(_valid) -> void:
	next_step()
