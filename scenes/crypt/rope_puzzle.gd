extends Node2D


enum State {
	LOWER, MID, UPPER,
}


@export var expected_lhs := State.MID
@export var expected_mid := State.UPPER
@export var expected_rhs := State.LOWER
@export var game_state: StateNode = null

@onready var lhs: Rope = %RopeLhs
@onready var mid: Rope = %RopeMid
@onready var rhs: Rope = %RopeRhs

@onready var lower_ray = %Low
@onready var mid_ray = %Mid
@onready var upper_ray = %Upper

var states: Dictionary[Rope, State] = {}


func _ready() -> void:
	states = {
		lhs: State.LOWER,
		mid: State.MID,
		rhs: State.UPPER,
	}


func _change_lhs_state() -> void:
	_next_state(lhs)
	_check_winning_combination()


func _change_mid_state() -> void:
	_next_state(mid)
	_check_winning_combination()


func _change_rhs_state() -> void:
	_next_state(rhs)
	_check_winning_combination()


func _next_state(rope: Rope) -> void:
	rope.play_audio()

	match states[rope]:
		State.LOWER:
			states[rope] = State.MID
			rope.global_position.y = mid_ray.global_position.y
		State.MID:
			states[rope] = State.UPPER
			rope.global_position.y = upper_ray.global_position.y
		State.UPPER:
			states[rope] = State.LOWER
			rope.global_position.y = lower_ray.global_position.y


func _check_winning_combination() -> void:
	if states[lhs] != expected_lhs:
		return

	if states[mid] != expected_mid:
		return

	if states[rhs] != expected_rhs:
		return

	game_state.finished.emit(
		"SolvedPuzzleState",
		Consts.Crypt.Puzzle.ROPES
	)
