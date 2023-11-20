class_name ScaleInfo
extends Resource

## Tonic note
@export var tonic: Globals.Tone = Globals.Tone.C
## Semi-tones from tonic note
@export var degrees: Array[int] = []
## Inversion: 0 to start at 1st degree, 1 to start at 2nd degree, 2 to start at 3rd degree, etc.
@export_range(0, 11) var inversion: int = 0
## Scale notes
@export var notes: Array[Globals.Tone] = []
