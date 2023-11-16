extends Tutorial

enum Step
{
	C,
	C_C,
	C_C_G,
	C_C_G_G,
}

var _texts: PackedStringArray = [
	"Your keyboard acts as a piano: the W key is the note C, E key is note D, R key is note E and so on.\nJump to hit the C block",
	"Hit the C block twice to replay the sequence",
	"Replay the sequence",
	"Replay the sequence",
]

func _get_texts() -> PackedStringArray:
	return _texts

func _on_block_sequence_sequence_finished(valid) -> void:
	if valid:
		next_step()
	else:
		set_step(0)
