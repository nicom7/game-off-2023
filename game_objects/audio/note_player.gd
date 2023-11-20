class_name NotePlayer
extends Node

@export var tone: Globals.Tone = Globals.Tone.A:
	set(value):
		if tone != value:
			tone = value
			_update_pitch()

@export var reference: Globals.Tone = Globals.Tone.A
@export var octave: int = 0:
	set(value):
		if octave != value:
			octave = value
			_update_pitch()

@export_range(0.01, 4) var pitch: float = 1:
	set(value):
		if pitch != value:
			pitch = value
			_update_pitch()

## Note playback duration in seconds. Set to 0 or less for infinite duration (until stopped manually).
@export var duration: float = 0

@export_group("Advanced")
@export_range(0, 1) var octave_ratio: float = 0.25
@export var playing: bool = false:
	set(value):
		if playing != value:
			playing = value
			_update_playing()

## True to keep the node active even after the stream player is finished, false to release it
@export var keep_alive: bool = false

@export_group("Envelope")
@export var attack_duration: float = 0.1
@export var release_duration: float = 0.5
@export var attack_curve: Curve
@export var release_curve: Curve

var playback: AudioStreamPlayback
@onready var player: AudioStreamPlayer = $AudioStreamPlayer
@onready var sample_hz = player.stream.mix_rate if player.stream else 1.0
@onready var sample_step = 1.0 / sample_hz
var cursor = 0.0
var phase_start_cursor = 0.0
var phase_start_volume = 0.0
var sustain_volume = 1.0

enum EnvelopePhase
{
	ATTACK,
	SUSTAIN,
	RELEASE,
}

var current_phase: EnvelopePhase = EnvelopePhase.ATTACK:
	set(value):
		current_phase = value
		phase_start_cursor = cursor

const SQRT_2 = sqrt(2.0)
const INV_SQRT_2 = sqrt(2.0) / 2
const INV_SQRT_2_VEC = Vector2.ONE * INV_SQRT_2

func start():
	(player.stream as AudioStreamWAV).loop_mode = AudioStreamWAV.LOOP_FORWARD

	player.volume_db = linear_to_db(0)
	current_phase = EnvelopePhase.ATTACK
	# Sustain volume is equal to last point of attack curve
	sustain_volume = attack_curve.sample_baked(1.0)
	player.play()
	playback = player.get_stream_playback()
	if duration > 0:
		$PlaybackTimer.wait_time = duration
		$PlaybackTimer.start()

func stop():
	(player.stream as AudioStreamWAV).loop_mode = AudioStreamWAV.LOOP_DISABLED

	current_phase = EnvelopePhase.RELEASE
	phase_start_volume = db_to_linear(player.volume_db)

func _update_pitch():
	if not is_node_ready():
		return

	if playback is AudioStreamGeneratorPlayback:
		$AudioStreamPlayer.pitch_scale = (2.0 ** octave) * pitch
	else:
		$AudioStreamPlayer.pitch_scale = (2.0 ** octave) * pitch * Config.tone_frequencies[tone] / Config.tone_frequencies[reference]

func _update_playing():
	if not is_node_ready():
		return

	if playing:
		start()
	else:
		stop()

func _ready():
	_update_pitch()

func _process(delta: float) -> void:
	if player.playing:
		_update_envelope()
		if playback is AudioStreamGeneratorPlayback:
			_fill_buffer()
		else:
			cursor = fmod(cursor + delta, 1000.0)

func _update_envelope():
	match current_phase:
		EnvelopePhase.ATTACK:
			var relative_time = remap(cursor, phase_start_cursor, phase_start_cursor + attack_duration, 0, 1)
			if relative_time > 1:
				current_phase = EnvelopePhase.SUSTAIN
			else:
				player.volume_db = linear_to_db(attack_curve.sample_baked(relative_time))

		EnvelopePhase.RELEASE:
			var relative_time = remap(cursor, phase_start_cursor, phase_start_cursor + release_duration, 0, 1)
			if relative_time > 1:
				player.stop()
				if not keep_alive:
					queue_free()
			else:
				player.volume_db = linear_to_db(_get_volume(relative_time, release_curve))

		EnvelopePhase.SUSTAIN:
			player.volume_db = linear_to_db(sustain_volume)


func _get_volume(time: float, curve: Curve) -> float:
	var relative_vol = curve.sample_baked(time)
	var v0 = curve.sample_baked(0)
	var v1 = curve.sample_baked(1)

	relative_vol = remap(relative_vol, v0, v1, phase_start_volume, v1)
	return relative_vol

func _fill_buffer():
	var gen_playback = playback as AudioStreamGeneratorPlayback
	var f1 = Config.tone_frequencies[tone]
	var f2 = Config.tone_frequencies[tone] * 2
	var frames_available = gen_playback.get_frames_available()

	for i in range(frames_available):
		gen_playback.push_frame(Vector2.ONE * (sin(TAU * f1 * cursor) * (1 - octave_ratio) + sin(TAU * f2 * cursor) * octave_ratio))
		cursor = fmod(cursor + sample_step, 1000.0)


func _on_playback_timer_timeout() -> void:
	stop()


func _on_audio_stream_player_finished() -> void:
	if not keep_alive:
		queue_free()
