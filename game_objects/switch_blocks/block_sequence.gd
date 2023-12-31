extends Node

@export var switch_blocks: Array[SwitchBlock] = []
@export_range(1, 99) var sequence_length_max: int = Globals.SEQUENCE_LENGTH_MAX
@export var randomize_sequence: bool = true
## The current block sequence as a list of block indexes (0 is the first platform block, 1 is the second, etc.)
@export var current_sequence: Array[int] = []
@export var active: bool = true

enum SequenceState
{
	DEMO,
	PLAYBACK,
	RECORD,
	FINISHED,
}

var _sequence_cursor: int = 0

var _current_sequence_end: int = 0
var _sequence_state: SequenceState = SequenceState.DEMO

signal sequence_finished(valid: bool)
signal sequence_played(demo_sequence: bool)
signal finished

func start() -> void:
	if not active or switch_blocks.is_empty():
		return

	_setup_blocks()
	_set_blocks_enabled(false)
	_sequence_state = SequenceState.DEMO
	_play_sequence(range(switch_blocks.size()))

func get_current_sequence_end() -> int:
	return _current_sequence_end

func _setup_blocks() -> void:
	for b in switch_blocks:
		if not b.is_hit.is_connected(_on_block_is_hit):
			b.is_hit.connect(_on_block_is_hit)

func _setup_next_sequence(reset: bool) -> void:
	if switch_blocks.is_empty():
		return

	_sequence_cursor = 0
	_set_blocks_enabled(false)

	if reset:
		if randomize_sequence:
			current_sequence.clear()
			for i in sequence_length_max:
				current_sequence.append(randi_range(0, switch_blocks.size() - 1))

		_current_sequence_end = 0
	else:
		_current_sequence_end += 1

	$SequenceTimer.start()

func _play_sequence(blocks: Array) -> void:
	_set_all_blocks_valid()

	var timer: Timer = $BlockTimer
	for b in blocks:
		switch_blocks[b].hit()
		timer.start()
		await $BlockTimer.timeout

	sequence_played.emit(_sequence_state == SequenceState.DEMO)

func _validate_block(block: SwitchBlock) -> bool:
	var valid = switch_blocks[current_sequence[_sequence_cursor]] == block
	return valid

func _set_all_blocks_valid() -> void:
	for b in switch_blocks:
		b.hit_valid = true

func _set_block_valid(block: int) -> void:
	for b in switch_blocks:
		b.hit_valid = false

	switch_blocks[block].hit_valid = true

func _set_blocks_enabled(enabled: bool) -> void:
	for b in switch_blocks:
		b.hit_detection_enabled = enabled

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_blocks()


func _on_sequence_timer_timeout() -> void:
	_play_sequence(current_sequence.slice(0, _current_sequence_end + 1))


func _on_sequence_played(_demo_sequence: bool) -> void:
	match _sequence_state:
		SequenceState.DEMO:
			_sequence_state = SequenceState.PLAYBACK
			_setup_next_sequence(true)
		SequenceState.PLAYBACK:
			_sequence_state = SequenceState.RECORD
			_set_blocks_enabled(true)
			_set_block_valid(current_sequence[_sequence_cursor])


func _on_block_is_hit(block: SwitchBlock) -> void:
	if _sequence_state == SequenceState.RECORD:
		var valid = _validate_block(block)
		if valid:
			if _sequence_cursor < _current_sequence_end:
				# Next block in sequence
				_sequence_cursor += 1
				_set_block_valid(current_sequence[_sequence_cursor])
			else:
				# Sequence finished; next sequence or success
				sequence_finished.emit(true)
				if _current_sequence_end < sequence_length_max - 1:
					_sequence_state = SequenceState.PLAYBACK
					_setup_next_sequence(false)
				else:
					# Block sequence success
					_set_blocks_enabled(false)
					_sequence_state = SequenceState.FINISHED
					finished.emit()
		else:
			# Reset current sequence
			sequence_finished.emit(false)
			_sequence_state = SequenceState.PLAYBACK
			_setup_next_sequence(true)
