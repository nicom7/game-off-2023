class_name FormattedRichTextLabel
extends RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	text = Globals.format_project_settings(text)
