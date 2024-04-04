@tool
extends CenterContainer

@export var tone: Globals.Tone = Globals.Tone.A:
	set(value):
		if tone != value:
			tone = value
			_update_labels()

## Display keyboard keys instead of tones
@export var show_keys: = false:
	set(value):
		show_keys = value
		if is_node_ready():
			%ToneLabel.visible = not show_keys
			%KeyCap.visible = show_keys


func _update_labels() -> void:
	if not is_node_ready():
		return

	var tone_color = Config.tone_colors[tone]
	var label = Globals.get_label_from_tone(tone)
	%ToneLabel.text = label
	%ToneLabel.self_modulate = tone_color.lightened(Globals.LIGHT_COLOR_AMOUNT)

	var key_label = "{%s}" % Globals.get_action_from_tone(tone)
	if not Engine.is_editor_hint():
		# Do not run the following in editor because it will crash
		key_label = Globals.format_input_actions(key_label)
	%KeyLabel.text = key_label
	%KeyLabel.self_modulate = tone_color.lightened(Globals.LIGHT_COLOR_AMOUNT)


func _update_label_sizes() -> void:
	%ToneLabel.scale = Vector2.ONE / remap(maxi(%ToneLabel.text.length(), 1), 1, 2, 1, 1.25)
	%ToneLabel.pivot_offset = %ToneLabel.size / 2


func _ready() -> void:
	_update_labels()
	_update_label_sizes()


func _process(_delta: float) -> void:
	_update_label_sizes()
