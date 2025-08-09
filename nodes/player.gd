class_name Player extends CharacterBody2D

enum State {
	STAND, MOVE,
}

enum Direction {
	LEFT, RIGHT, TOP, BOTTOM,
}

@export var speed = 400

@onready var animatedSprite = $AnimatedSprite2D
@onready var horizontalCollider = $HorizontalCollider
@onready var verticalCollider = $VerticalCollider

var current_state = State.STAND
var current_direction = Direction.RIGHT
var is_player_controlling = true

var _still = false


func _ready() -> void:
	LevelStateMachine.message_visible.connect(_set_still_state)


@warning_ignore("unused_parameter")
func _physics_process(delta: float):
	if is_player_controlling:
		get_input()
	else:
		updatePlayerState()
		updatePlayerAnimationState()
		updatePlayerCollider()

	move_and_slide()


func get_input():
	var input_direction

	if _still:
		input_direction = Vector2(0, 0)
	else:
		input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	velocity = input_direction * speed

	updatePlayerState()
	updatePlayerAnimationState()
	updatePlayerCollider()


func updatePlayerState():
	match [velocity.x, velocity.y]:
		[var x, var y] when x == y && x == 0:
			current_state = State.STAND
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


func updatePlayerAnimationState():
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


func updatePlayerCollider():
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


func _set_still_state(message_visible):
	_still = message_visible
