extends "res://scripts/state_machine/state_node.gd"


@export var player: Player = null
@export var animation_player: AnimationPlayer = null


func enter() -> void:
	super.enter()

	player.current_state = Player.State.LIE
	player.is_player_controlling = false
	animation_player.play("blinking")


@warning_ignore("unused_parameter")
func process(delta: float) -> void:
	if not animation_player.is_playing():
		finished.emit(null)


func exit() -> void:
	player.current_state = Player.State.STAND
	player.current_direction = Player.Direction.LEFT
	player.is_player_controlling = true
