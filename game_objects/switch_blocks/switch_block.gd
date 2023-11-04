@tool
class_name SwitchBlock
extends Node2D

@export var tone: Globals.Tone = Globals.Tone.A:
	set(value):
		if tone != value:
			tone = value
			_update_block()

func _update_block() -> void:
	if not is_node_ready():
		return
		
	modulate = Globals.tone_color[tone]
	$Tone.frame = tone
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
