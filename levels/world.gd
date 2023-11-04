extends Node2D

var player_tone: Globals.Tone
@export var ambient_note_player_scene: PackedScene
var ambient_note_player: NotePlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_current_tone_changed(tone: Globals.Tone) -> void:
	player_tone = tone
	if ambient_note_player:
		ambient_note_player.tone = player_tone

func _on_player_on_floor_changed(value) -> void:
	if value:
		ambient_note_player = ambient_note_player_scene.instantiate()
		ambient_note_player.tone = player_tone
		add_child(ambient_note_player)
		ambient_note_player.start()
	else:
		ambient_note_player.stop()
		ambient_note_player = null
