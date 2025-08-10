extends "res://scripts/state_machine/state_node.gd"


@export var player: Player = null
@export var animation_player: AnimationPlayer = null


func enter() -> void:
	super.enter()

	player.is_player_controlling = false
	animation_player.play("blinking")


@warning_ignore("unused_parameter")
func process(delta: float) -> void:
	if not animation_player.is_playing():
		finished.emit(null)


func exit() -> void:
	player.is_player_controlling = true
