extends Tutorial

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
	"Press {C_note} to jump",
	"Press {G_note} to climb up the ladder",
	"Hold {G_note} to reach the G platform",
	"Press {G_note} to jump",
	"Press {C_note} to climb down",
	"Hold {C_note} to reach the C platform",
]
var _player_tone: Globals.Tone
var _player_on_floor: bool = false

func _get_texts() -> PackedStringArray:
	return _texts

func _setup_texts() -> void:
	var new_texts: PackedStringArray = []
	for t in _texts:
		new_texts.append(Globals.format_input_actions(t))

	_texts = new_texts

func _ready() -> void:
	_setup_texts()

func _on_player_jumped(_notes) -> void:
	match _step:
		Step.C_JUMP:
			if _player_tone == Globals.Tone.C:
				next_step()
		Step.G_JUMP:
			if _player_tone == Globals.Tone.G:
				next_step()


func _on_player_current_tone_changed(tone, _octave) -> void:
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
