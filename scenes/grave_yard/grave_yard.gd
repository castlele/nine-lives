extends Node2D


func _ready() -> void:
	LevelStateMachine.enqueue_messages([
		"Hello",
		"World",
	])
