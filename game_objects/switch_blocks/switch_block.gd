@tool
class_name SwitchBlock
extends Node2D

signal hit(block: SwitchBlock)

@export var tone: Globals.Tone = Globals.Tone.A:
	set(value):
		if tone != value:
			tone = value
			_update_block()
			
@export var hit_note_player_scene: PackedScene
var hit_note_player: NotePlayer

func _update_block() -> void:
	if not is_node_ready():
		return
		
	modulate = Globals.tone_color[tone]
	$Tone.frame = tone
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_block()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hit_detection_body_entered(body: Node2D) -> void:
	var character = body as Character
	if character and character.velocity.y < 0:
		hit.emit(self)
		
func _on_hit(block: SwitchBlock) -> void:
	hit_note_player = hit_note_player_scene.instantiate()
	hit_note_player.tone = tone
	hit_note_player.octave_ratio = 1
	add_child(hit_note_player)
	hit_note_player.start()
	$NotePlayerTimer.start()


func _on_note_player_timer_timeout() -> void:
	hit_note_player = hit_note_player_scene.instantiate()
	hit_note_player.tone = tone
	hit_note_player.octave_ratio = 0.2
	add_child(hit_note_player)
	hit_note_player.start()
