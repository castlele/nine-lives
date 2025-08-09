@tool
extends "res://nodes/interatable/interactable.gd"


var sm: OwnersGraveStateMachine = null


func _interact_with_player() -> void:
	super._interact_with_player()

	sm.make_interaction()
