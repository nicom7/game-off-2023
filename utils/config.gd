@tool
extends Node

@export var tone_frequencies: Array[float] = [
	220,		# A
	246.94,		# B
	261.63,		# C
	293.66,		# D
	329.63,		# E
	349.23,		# F
	392,		# G
	233.08,		# A#
	277.18,		# C#
	311.13,		# D#
	369.99,		# F#
	415.3		# G#
]

@export var tone_colors: Array[Color] = [
	Color(1, 0, 0),		# A		0
	Color(1, 1, 0),		# B		60
	Color(0.5, 1, 0),	# C		90
	Color(0, 1, 0.5),	# D		150
	Color(0, 0.5, 1),	# E		210
	Color(0, 0, 1),		# F		240
	Color(1, 0, 1),		# G		300
	Color(1, 0.5, 0),	# A#	30
	Color(0, 1, 0),		# C#	120
	Color(0, 1, 1),		# D#	180
	Color(0.5, 0, 1),	# F#	270
	Color(1, 0, 0.5),	# G#	330
]

@export var tone_labels: PackedStringArray = [
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"A♯",
	"C♯",
	"D♯",
	"F♯",
	"G♯",
]
