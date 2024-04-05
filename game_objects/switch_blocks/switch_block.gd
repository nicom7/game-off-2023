@tool
class_name SwitchBlock
extends Node2D

signal is_hit(block: SwitchBlock)
signal body_entered(body: Node2D)

@export var tone: Globals.Tone = Globals.Tone.A:
	set(value):
		if tone != value:
			tone = value
			_update_block()

## Display keyboard keys instead of tones
@export var show_keys: = false:
	set(value):
		if show_keys != value:
			show_keys = value
			_update_show_keys()

@export var octave: int = 0
@export var hit_valid: bool = true

@export var block_note_player_scene: PackedScene
var block_note_player: NotePlayer

var hit_detection_enabled: bool:
	get:
		if is_node_ready():
			return $HitDetection.monitoring
		return false
	set(value):
		if is_node_ready():
			$HitDetection.set_deferred("monitoring", value)

var _cur_hit_valid: bool = false


func hit() -> void:
	_cur_hit_valid = hit_valid
	is_hit.emit(self)

	$AnimationPlayer.stop()
	$AnimationPlayer.play("hit_valid" if _cur_hit_valid else "hit_invalid")
	block_note_player = block_note_player_scene.instantiate()
	block_note_player.tone = tone
	block_note_player.octave = octave
	block_note_player.pitch = 4.0 if _cur_hit_valid else 0.7
	add_child(block_note_player)
	block_note_player.start()
	$NotePlayerTimer.start()


func _update_block() -> void:
	if not is_node_ready():
		return

	%ToneLabel.tone = tone

	var tone_color = Config.tone_colors[tone]
	%Block.self_modulate = tone_color
	%HitVFX.self_modulate = tone_color.lightened(Globals.LIGHT_COLOR_AMOUNT)


func _update_show_keys() -> void:
	%ToneLabel.show_keys = show_keys


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_block()
	_update_show_keys()


func _on_hit_detection_body_entered(body: Node2D) -> void:
	body_entered.emit(body)


func _on_body_entered(body: Node2D) -> void:
	var character = body as Character
	if character:
		if character.velocity.y < 0:
			# Hit from below
			hit()


func _on_note_player_timer_timeout() -> void:
	block_note_player = block_note_player_scene.instantiate()
	block_note_player.tone = tone
	block_note_player.octave = octave
	block_note_player.pitch = 2.0 if _cur_hit_valid else 0.6
	add_child(block_note_player)
	block_note_player.start()
