extends Node

@export_range(1, 99) var sequence_length_max: int = 7

var _blocks: Array[SwitchBlock] = []
var _current_sequence: Array[int] = []

signal sequence_played

func _play_sequence(blocks: Array) -> void:
	var timer: Timer = $BlockTimer
	for b in blocks:
		_blocks[b].hit()
		timer.start()
		await $BlockTimer.timeout
	
	sequence_played.emit()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for c in get_children():
		if c is SwitchBlock:
			_blocks.append(c)
			
	_play_sequence(range(_blocks.size()))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_sequence_timer_timeout() -> void:
	if _current_sequence.size() < sequence_length_max:
		_current_sequence.append(randi_range(0, _blocks.size() - 1))
		_play_sequence(_current_sequence)


func _on_sequence_played() -> void:
	$SequenceTimer.start()
