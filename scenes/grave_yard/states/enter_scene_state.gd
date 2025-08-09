extends "res://scripts/state_machine/state_node.gd"


@export var player: Player = null
@export var path: PathFollow2D = null
@export var mock_node: Node2D = null
@export var speed := 100

var _entered_into_scene: bool:
	get:
		return path.progress_ratio >= 1


func enter() -> void:
	super.enter()

	player.global_position = mock_node.global_position


func process(delta: float) -> void:
	super.process(delta)

	if _entered_into_scene:
		finished.emit("GameState")
		return

	path.progress += speed * delta
	player.global_position = mock_node.global_position
