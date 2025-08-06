extends StaticBody2D


@onready var interactable: Interactable = $Interactable

var _sm := OwnersGraveStateMachine.new()


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if interactable.is_player_around:
		_listen_events()


func _listen_events() -> void:
	if Input.is_action_just_pressed("interaction"):
		_sm.make_interaction()
