extends StaticBody2D


@export var player: Player = null
@export var game_state: StateNode = null

@onready var interactable: Interactable = $Interactable
@onready var fish_anchor: Node2D = $FishAnchor

var _fish_node = preload("res://nodes/grave/fish.tscn")
var _sm := OwnersGraveStateMachine.new()


func _ready() -> void:
	assert(player)
	assert(game_state)

	interactable.sm = _sm
	interactable.player = player
	_sm.player_bring_fish.connect(_place_fish)


func _place_fish(collectable: CollectableData) -> void:
	var fish: Collectable = _fish_node.instantiate()

	assert(fish)

	fish.data = collectable

	fish_anchor.call_deferred("add_child", fish)

	# if not player.on_the_grave():
	# 	move_player_in_front_of_grave()

	game_state.finished.emit("SleepState")
