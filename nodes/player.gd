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

var _currentState = State.STAND
var _currentDirection = Direction.RIGHT
var _still = false


func _ready() -> void:
	LevelStateMachine.message_visible.connect(_set_still_state)


@warning_ignore("unused_parameter")
func _physics_process(delta: float):
	get_input()
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
			_currentState = State.STAND
		[var x, _] when x > 0:
			_currentState = State.MOVE
			_currentDirection = Direction.RIGHT
		[var x, _] when x < 0:
			_currentState = State.MOVE
			_currentDirection = Direction.LEFT
		[_, var y] when y > 0:
			_currentState = State.MOVE
			_currentDirection = Direction.BOTTOM
		[_, var y] when y < 0:
			_currentState = State.MOVE
			_currentDirection = Direction.TOP


func updatePlayerAnimationState():
	var action = State.keys()[_currentState].to_lower()
	var direction: String

	if _currentDirection == Direction.LEFT:
		direction = Direction.keys()[Direction.RIGHT].to_lower()
		animatedSprite.flip_h = true
	else:
		direction = Direction.keys()[_currentDirection].to_lower()
		animatedSprite.flip_h = false

	var animationName = action + "_" + direction
	animatedSprite.play(animationName)


func updatePlayerCollider():
	if _currentDirection == Direction.RIGHT:
		horizontalCollider.position.x = 64

	if _currentDirection == Direction.LEFT:
		horizontalCollider.position.x = 45

	match _currentDirection:
		Direction.LEFT, Direction.RIGHT:
			horizontalCollider.disabled = false
			verticalCollider.disabled = true
		Direction.TOP, Direction.BOTTOM:
			horizontalCollider.disabled = true
			verticalCollider.disabled = false


func _set_still_state(message_visible):
	_still = message_visible
