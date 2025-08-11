extends "res://scripts/state_machine/state_node.gd"


@export var player: Player = null
@export var player_target_node: Node2D = null
@export var animation_player: AnimationPlayer = null

var _animation_started := false


func enter() -> void:
	super.enter()

	player.is_player_controlling = false
	player.nav_agent.target_position = player_target_node.global_position
	player.nav_agent.navigation_finished.connect(_play_animation)


@warning_ignore("unused_parameter")
func process(delta: float) -> void:
	if _animation_started and not animation_player.is_playing():
		finished.emit(null)


func exit() -> void:
	player.is_player_controlling = true


func _play_animation() -> void:
	_animation_started = true
	animation_player.play("blinking")
