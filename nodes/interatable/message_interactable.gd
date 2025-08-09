extends Node2D


@export var prefs: MessageInteractablePref = null

@onready var interactable: Interactable = $Interactable


func _ready() -> void:
	interactable.prefs = prefs.interactable_prefs


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
	#if interactable.is_player_around:
		#_listen_events()


func _listen_events() -> void:
	if Input.is_action_just_pressed("interaction"):
		LevelStateMachine.enqueue_messages(prefs.messages.duplicate())
