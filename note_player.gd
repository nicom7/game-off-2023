class_name NotePlayer
extends Node

@export var tone: Globals.Tone = Globals.Tone.A
@export_range(0, 1) var octave_ratio: float = 0.25

@export_group("Envelope")
@export var attack_duration: float = 0.1
@export var release_duration: float = 0.5
@export var attack_curve: Curve
@export var release_curve: Curve

var playback: AudioStreamGeneratorPlayback
@onready var player: AudioStreamPlayer = $AudioStreamPlayer
@onready var sample_hz = player.stream.mix_rate
@onready var sample_step = 1.0 / sample_hz
var tone_frequencies: Array[float] = [220, 246.94, 261.63, 293.66, 329.63, 349.23, 392] # The frequency of the sound wave.
var cursor = 0.0
var phase_start_cursor = 0.0

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
	print("-> attack")
	current_phase = EnvelopePhase.ATTACK
	print("play")
	player.play()
	playback = player.get_stream_playback()

func stop():
	print("-> release")
	current_phase = EnvelopePhase.RELEASE

func _ready():
	pass

func _process(delta: float) -> void:
	if player.playing:
		_update_envelope()
		_fill_buffer()

func _update_envelope():
	var gain: float
	match current_phase:
		EnvelopePhase.ATTACK:
			var relative_time = remap(cursor, phase_start_cursor, phase_start_cursor + attack_duration, 0, 1)
			if relative_time > 1:
				print("-> sustain")
				current_phase = EnvelopePhase.SUSTAIN
			else:
				player.volume_db = linear_to_db(attack_curve.sample_baked(relative_time))
		EnvelopePhase.RELEASE:
			var relative_time = remap(cursor, phase_start_cursor, phase_start_cursor + release_duration, 0, 1)
			if relative_time > 1:
				print("stop")
				player.stop()
				queue_free()
			else:
				player.volume_db = linear_to_db(release_curve.sample_baked(relative_time))
		EnvelopePhase.SUSTAIN:
			player.volume_db = 0
		
func _fill_buffer():
	if !playback:
		return

	var f1 = tone_frequencies[tone]
	var f2 = tone_frequencies[tone] * 2
	var frames_available = playback.get_frames_available()
#	print("fill buffer, ", frames_available)

	for i in range(frames_available):
		playback.push_frame(Vector2.ONE * (sin(TAU * f1 * cursor) * (1 - octave_ratio) + sin(TAU * f2 * cursor) * octave_ratio))
		cursor = fmod(cursor + sample_step, 1000.0)
