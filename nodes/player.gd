class_name Player extends CharacterBody2D

enum State {
	STAND, MOVE, LIE,
}

enum Direction {
	LEFT, RIGHT, TOP, BOTTOM,
}


@export var speed = 400
@export var is_ghost = false
@export var current_state = State.STAND
@export var current_direction = Direction.RIGHT

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var tail_sprite: Sprite2D = $TailMarker/TailSprite
@onready var horizontalCollider = $HorizontalCollider
@onready var verticalCollider = $VerticalCollider
@onready var ghost_light: PointLight2D = $GhostLight
@onready var nav_agent: NavigationAgent2D = $NavAgent

var is_player_controlling = true
var _still = false


func _ready() -> void:
	LevelStateMachine.message_visible.connect(_set_still_state)


@warning_ignore("unused_parameter")
func _physics_process(delta: float):
	_update_ghost_state()

	if is_player_controlling:
		_get_input()
	else:
		_follow_path()
		_update_player_state()
		_update_player_animation_state()

	move_and_slide()


func _get_input():
	var input_direction

	if _still:
		input_direction = Vector2(0, 0)
	else:
		input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	velocity = input_direction * speed

	_update_player_state()
	_update_player_animation_state()


func _update_player_state():
	match [velocity.x, velocity.y]:
		[var x, var y] when x == y && x == 0:
			if current_state != State.LIE:
				current_state = State.STAND
			else:
				current_direction = Direction.BOTTOM
		[var x, _] when x > 0:
			current_state = State.MOVE
			current_direction = Direction.RIGHT
		[var x, _] when x < 0:
			current_state = State.MOVE
			current_direction = Direction.LEFT
		[_, var y] when y > 0:
			current_state = State.MOVE
			current_direction = Direction.BOTTOM
		[_, var y] when y < 0:
			current_state = State.MOVE
			current_direction = Direction.TOP


func _update_player_animation_state():
	var action = State.keys()[current_state].to_lower()
	var direction: String

	direction = Direction.keys()[current_direction].to_lower()

	var animationName = action + "_" + direction
	animation_player.play(animationName)


func _follow_path() -> void:
	if not nav_agent.is_target_reachable() or nav_agent.is_target_reached():
		velocity.x = 0
		velocity.y = 0
		return

	var next_path_pos := nav_agent.get_next_path_position()
	var direction := global_position.direction_to(next_path_pos)
	velocity = direction * speed


func _set_still_state(message_visible):
	_still = message_visible


func _update_ghost_state():
	animated_sprite.use_parent_material = not is_ghost
	tail_sprite.use_parent_material = not is_ghost
	ghost_light.visible = is_ghost
