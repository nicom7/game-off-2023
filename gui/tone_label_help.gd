@tool
class_name ToneLabel
extends CenterContainer

@export var tone: = Globals.Tone.A:
	set(value):
		tone = value
		_update_label()

func _ready() -> void:
	_update_label()

func _update_label() -> void:
	if not is_node_ready():
		return

	var tone_color = Config.tone_colors[tone]
	%Label.self_modulate = tone_color.lightened(Globals.LIGHT_COLOR_AMOUNT)
	var label = Globals.get_label_from_tone(tone)

	%Label.text = label
