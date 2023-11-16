extends CanvasLayer

signal finished

enum Step
{
	MOVE,
	C_JUMP,
	CLIMB_UP_START,
	CLIMB_UP_END,
	G_JUMP,
	CLIMB_DOWN_START,
	CLIMB_DOWN_END,
}

var _texts: PackedStringArray = [
	"Hold → or ← to move",
	"Press W to jump",
	"Press Y to climb up the ladder",
	"Hold Y to reach the G platform",
	"Press Y to jump",
	"Press W to climb down",
	"Hold W to reach the C platform",
]
var _step: int = -1
var _player_tone: Globals.Tone
var _player_on_floor: bool = false

func current_step():
	return _step

func next_step():
	_step += 1
	if _step >= Step.keys().size():
		$Step/Label.text = "Well done!"
		finished.emit()
	else:
		$Step/Label.text = _texts[_step]

func _on_player_jumped(_notes) -> void:
	match _step:
		Step.C_JUMP:
			if _player_tone == Globals.Tone.C:
				next_step()
		Step.G_JUMP:
			if _player_tone == Globals.Tone.G:
				next_step()

func _on_player_interact(_player, _notes) -> void:
	pass # Replace with function body.


func _on_player_current_tone_changed(tone) -> void:
	_player_tone = tone


func _on_player_direction_changed(direction) -> void:
	match _step:
		Step.MOVE:
			if direction.x:
				next_step()
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
			if _player_tone == Globals.Tone.G and _player_on_floor:
				next_step()
		Step.CLIMB_DOWN_END:
			if _player_tone == Globals.Tone.C and _player_on_floor:
				next_step()
