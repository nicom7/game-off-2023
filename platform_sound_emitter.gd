extends AudioStreamPlayer

@export var tone: Globals.Tone = Globals.Tone.A
@export_range(0, 1) var octave_ratio: float = 0.0

var playback: AudioStreamGeneratorPlayback
@onready var sample_hz = stream.mix_rate
@onready var sample_step = 1.0 / sample_hz
var tone_frequencies: Array[float] = [220, 246.94, 261.63, 293.66, 329.63, 349.23, 392] # The frequency of the sound wave.
var cursor = 0.0

const SQRT_2 = sqrt(2.0)
const INV_SQRT_2 = sqrt(2.0) / 2
const INV_SQRT_2_VEC = Vector2.ONE * INV_SQRT_2

func _ready():
	play()
	playback = get_stream_playback()
	fill_buffer()
	
func _process(delta: float) -> void:
	fill_buffer()

func fill_buffer():
	var f1 = tone_frequencies[tone]
	var f2 = tone_frequencies[tone] * 2
	var frames_available = playback.get_frames_available()
	print("fill buffer, ", frames_available)

	for i in range(frames_available):
		playback.push_frame(Vector2.ONE * (sin(TAU * f1 * cursor) * (1 - octave_ratio) + sin(TAU * f2 * cursor) * octave_ratio))
		cursor = fmod(cursor + sample_step, 1000.0)
