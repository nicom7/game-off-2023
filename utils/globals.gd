class_name Globals
extends Object

enum Tone
{
	A,
	AS,
	B,
	C,
	CS,
	D,
	DS,
	E,
	F,
	FS,
	G,
	GS,
}

const ACTION_SUFFIX: String = "_note"

const STAGE_COUNT_MAX: int = 7
const NOTES_PER_STAGE_MAX: int = 2
const SEQUENCE_LENGTH_MAX: int = 4
const LIGHT_COLOR_AMOUNT: float = 0.5

static var _inputs: Dictionary = {}

static func get_label_from_tone(tone: Tone) -> String:
	if Config.is_node_ready():
		return Config.tone_labels[tone]

	printerr("Config node is not ready")
	return Tone.keys()[tone]

static func get_action_from_tone(tone: Tone) -> String:
	if Config.is_node_ready():
		return Config.tone_labels_desktop[tone] + ACTION_SUFFIX

	printerr("Config node is not ready")
	return Tone.keys()[tone] + ACTION_SUFFIX

static func get_all_tone_actions() -> PackedStringArray:
	var actions: PackedStringArray = []
	for tone in Tone.size():
		actions.append(get_action_from_tone(tone))

	return actions

static func get_note_from_degree(degree: int, tonic: Tone) -> Tone:
	return posmod(tonic + degree, Tone.size()) as Tone

## Replace all occurences of {...} with the 1st corresponding key label occurence for the specified action in curly braces
static func format_input_actions(string: String) -> String:
	if _inputs.is_empty():
		# Lazy-initialization of _inputs dictionary
		var tone_actions: PackedStringArray = InputMap.get_actions()

		for action in tone_actions:
			var action_events = InputMap.action_get_events(action)
			if not action_events.is_empty():
				var ev: InputEventKey = InputMap.action_get_events(action)[0] as InputEventKey
				if ev:
					var kc: Key = DisplayServer.keyboard_get_keycode_from_physical(
						ev.physical_keycode if ev.physical_keycode != 0 else ev.keycode)
					# Use keycode string if character is non-printable
					_inputs[action] = OS.get_keycode_string(kc) if (kc & Key.KEY_SPECIAL) else String.chr(kc)

	return string.format(_inputs)

## Replace project setting configs in curly braces with their corresponding values
static func format_project_settings(string: String) -> String:
	var settings: Dictionary = {}

	var tokens: PackedStringArray = string.split("{", false)
	for i in tokens.size():
		tokens[i] = tokens[i].get_slice("}", 0)
		settings[tokens[i]] = ProjectSettings.get_setting(tokens[i])

	return string.format(settings)

static func get_notes_from_bitfield(notes: int) -> Array[Tone]:
	var notes_array: Array[Tone] = []
	for tone in Tone.size():
		if notes & (1 << tone):
			notes_array.append(tone)

	return notes_array

static func get_bitfield_from_notes(notes: Array[Tone]) -> int:
	var bitfield: int = 0
	for tone in notes:
		bitfield |= (1 << tone)

	return bitfield
