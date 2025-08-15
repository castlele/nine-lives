extends "res://scripts/state_machine/state_node.gd"


@export var player: Player = null
@export var path: PathFollow2D = null
@export var mock_node: Node2D = null
@export var speed := 100

var _entered_into_scene: bool:
	get:
		return path.progress_ratio >= 1


func enter(args: Variant = null) -> void:
	super.enter(args)

	player.is_player_controlling = false
	player.global_position = mock_node.global_position
	player.current_state = Player.State.MOVE
	player.current_direction = Player.Direction.TOP
	player.velocity.y = -1


func process(delta: float) -> void:
	super.process(delta)

	if _entered_into_scene:
		finished.emit("GameState")
		return

	path.progress += speed * delta
	player.global_position = mock_node.global_position

func exit() -> void:
	player.velocity.x = 0
	player.is_player_controlling = true
