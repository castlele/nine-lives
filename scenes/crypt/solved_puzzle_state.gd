extends "res://scripts/state_machine/state_node.gd"


var puzzle_type: Consts.Crypt.Puzzle


func enter(args: Variant = null) -> void:
	_parse_args(args)

	super.enter(args)

	_finish_puzzle()
	finished.emit(null)


func _finish_puzzle() -> void:
	match puzzle_type:
		Consts.Crypt.Puzzle.NONE:
			return
		Consts.Crypt.Puzzle.ROPES:
			_finish_ropes_puzzle()


func _parse_args(args: Variant) -> void:
	puzzle_type = Consts.Crypt.Puzzle.NONE

	assert(args)
	assert(args is Consts.Crypt.Puzzle)

	puzzle_type = args

	assert(puzzle_type != Consts.Crypt.Puzzle.NONE)


func _finish_ropes_puzzle() -> void:
	print("Dropping mirror")
