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
@export var nav_agent: NavigationAgent2D = null

@onready var animatedSprite = $AnimatedSprite2D
@onready var horizontalCollider = $HorizontalCollider
@onready var verticalCollider = $VerticalCollider
@onready var ghost_light: PointLight2D = $AnimatedSprite2D/GhostLight

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
		_update_player_collider()

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
	_update_player_collider()


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

	if current_direction == Direction.LEFT:
		direction = Direction.keys()[Direction.RIGHT].to_lower()
		animatedSprite.flip_h = true
	else:
		direction = Direction.keys()[current_direction].to_lower()
		animatedSprite.flip_h = false

	var animationName = action + "_" + direction
	animatedSprite.play(animationName)


func _update_player_collider():
	if current_direction == Direction.RIGHT:
		horizontalCollider.position.x = 64

	if current_direction == Direction.LEFT:
		horizontalCollider.position.x = 45

	match current_direction:
		Direction.LEFT, Direction.RIGHT:
			horizontalCollider.disabled = false
			verticalCollider.disabled = true
		Direction.TOP, Direction.BOTTOM:
			horizontalCollider.disabled = true
			verticalCollider.disabled = false
		_:
			horizontalCollider.disabled = true
			verticalCollider.disabled = true


func _follow_path() -> void:
	if not nav_agent.is_target_reachable() and nav_agent.is_target_reached():
		return

	var next_path_pos := nav_agent.get_next_path_position()
	var direction := global_position.direction_to(next_path_pos)
	velocity = direction * speed


func _set_still_state(message_visible):
	_still = message_visible


func _update_ghost_state():
	animatedSprite.use_parent_material = not is_ghost
	ghost_light.visible = is_ghost
