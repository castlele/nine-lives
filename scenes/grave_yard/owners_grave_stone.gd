extends StaticBody2D


@onready var interactable: Interactable = $Interactable
@onready var fish_anchor: Node2D = $FishAnchor

var _fish_node = preload("res://nodes/grave/fish.tscn")
var _sm := OwnersGraveStateMachine.new()


func _ready() -> void:
	_sm.player_bring_fish.connect(_place_fish)


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if interactable.is_player_around:
		_listen_events()


func _listen_events() -> void:
	if Input.is_action_just_pressed("interaction"):
		_sm.make_interaction()


func _place_fish(collectable: CollectableData) -> void:
	var fish: Collectable = _fish_node.instantiate()

	assert(fish)

	fish.data = collectable

	fish_anchor.call_deferred("add_child", fish)
