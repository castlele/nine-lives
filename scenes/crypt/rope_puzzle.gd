extends Node2D


enum State {
	LOWER, MID, UPPER,
}


@onready var lhs = %RopeLhs
@onready var mid = %RopeMid
@onready var rhs = %RopeRhs

@onready var lower_ray = %Low
@onready var mid_ray = %Mid
@onready var upper_ray = %Upper

var states: Dictionary[Node2D, State] = {}


func _ready() -> void:
	states = {
		lhs: State.LOWER,
		mid: State.MID,
		rhs: State.UPPER,
	}


func _change_lhs_state() -> void:
	_next_state(lhs)


func _change_mid_state() -> void:
	_next_state(mid)


func _change_rhs_state() -> void:
	_next_state(rhs)


func _next_state(rope: Node2D) -> void:
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
