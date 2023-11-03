extends Node2D

var player_tone: Globals.Tone
var note_player_scene: PackedScene = preload("res://note_player.tscn")
var note_player: NotePlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_current_tone_changed(tone: Globals.Tone) -> void:
	player_tone = tone
	if note_player:
		note_player.tone = player_tone

func _on_player_on_floor_changed(value) -> void:
	if value:
		note_player = note_player_scene.instantiate()
		note_player.tone = player_tone
		add_child(note_player)
		note_player.start()
	else:
		note_player.stop()
		note_player = null
