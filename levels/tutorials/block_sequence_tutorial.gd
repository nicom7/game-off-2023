extends Tutorial

enum Step
{
	C,
	C_C,
	C_C_G,
	C_C_G_G,
}

var _texts: PackedStringArray = [
	"Your keyboard acts as a piano:\nthe W key is the note C, E key is note D, R key is note E and so on.\n\nJump to hit the C block",
	"Hit the C block twice to replay the sequence",
	"Replay the sequence",
	"Replay the sequence",
]

func _get_texts() -> PackedStringArray:
	return _texts

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
