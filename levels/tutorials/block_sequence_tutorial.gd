extends Tutorial

enum Step
{
	C,
	C_C,
	C_C_G,
	C_C_G_G,
}

var _texts: PackedStringArray = [
	"Use your keyboard like a piano:\nThe {C_note} key is the note C, {D_note} key is note D, {E_note} key is note E and so on.\n\nPress {C_note} to jump and hit the C block",
	"Hit the C block twice to replay the sequence",
	"Replay the C, C, G sequence",
	"Replay the sequence",
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
	if valid:
		$Step/Label.text = "Great!"
	else:
		$Step/Label.text = "Try again!"
		set_step(-1)


func _on_block_sequence_sequence_played(demo_sequence) -> void:
	if !demo_sequence:
		next_step()


func _on_block_sequence_finished() -> void:
	next_step()
