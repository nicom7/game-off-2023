extends CanvasLayer

@export var master_volume: float = 0

signal finished(anim_name: String)

func fade_in() -> void:
	$AnimationPlayer.play("fade_in")

func fade_out() -> void:
	$AnimationPlayer.play("fade_out")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.animation_finished.connect(_on_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	AudioServer.set_bus_volume_db(0, master_volume)

func _on_finished(anim_name: String) -> void:
	finished.emit(anim_name)
