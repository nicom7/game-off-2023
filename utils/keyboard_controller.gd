extends Node

## Bitfield of ToneFlags for previously pressed notes
var previous_notes: int = 0
## Bitfield of ToneFlags for currently pressed notes
var current_notes: int = 0

signal notes_changed(prev: int, cur: int)

@onready var _debounce_timer: Timer = $Timer
var _new_notes: int = 0

func get_action_strength(notes: int) -> float:
	return 1.0 if current_notes == notes else 0.0

func _input(event: InputEvent) -> void:
	var new_notes: int = _new_notes

	for tone in Globals.Tone.size():
		var action = Globals.get_action_from_tone(tone)
		if event.is_action_pressed(action):
			new_notes |= (1 << tone)
		elif event.is_action_released(action):
			new_notes &= ~(1 << tone)

	if new_notes != _new_notes:
		_new_notes = new_notes
		_debounce_timer.start()


func _on_timer_timeout() -> void:
	previous_notes = current_notes
	current_notes = _new_notes
	notes_changed.emit(previous_notes, current_notes)
#	print(Globals.get_notes_from_bitfield(previous_notes), " => ", Globals.get_notes_from_bitfield(current_notes))
