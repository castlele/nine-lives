class_name NextLevelEntrence extends Area2D


@export var current_level: LevelStateMachine.Scene


func on_player_entered(body: Node2D) -> void:
	assert(body is Player)
	LevelStateMachine.load_scene(_next_level())


func _next_level() -> LevelStateMachine.Scene:
	var next: LevelStateMachine.Scene

	match current_level:
		LevelStateMachine.Scene.MAIN:
			next = LevelStateMachine.Scene.GRAVE_YARD
		LevelStateMachine.Scene.GRAVE_YARD:
			next = LevelStateMachine.Scene.CRYPT
		LevelStateMachine.Scene.CRYPT:
			next = LevelStateMachine.Scene.CAVE

	return next
