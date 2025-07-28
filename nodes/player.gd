extends CharacterBody2D

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

func _physics_process(delta: float):
	get_input()
	move_and_slide()

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
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
	var direction = Direction.keys()[_currentDirection].to_lower()
	var animationName = action + "_" + direction

	animatedSprite.play(animationName)

func updatePlayerCollider():
	match _currentDirection:
		Direction.LEFT, Direction.RIGHT:
			horizontalCollider.show()
			verticalCollider.hide()
		Direction.TOP, Direction.BOTTOM:
			horizontalCollider.hide()
			verticalCollider.show()
