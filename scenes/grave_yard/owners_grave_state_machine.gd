class_name OwnersGraveStateMachine extends Object


enum Stage {
	FIRST,
	FIRST_HINT,
}


var _current_stage := Stage.FIRST


func make_interaction():
	match _current_stage:
		Stage.FIRST:
			_current_stage = Stage.FIRST_HINT
			LevelStateMachine.enqueue_messages([
				"\"bla bla bla\""
			])
		Stage.FIRST_HINT:
			LevelStateMachine.enqueue_messages([
				"\"I think, he would be happy to have a fresh fish for dinner!\"",
				"\"I remember somewhere here was a path to the lake\"",
			])
