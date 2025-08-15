extends StaticBody2D


@export var game_state: StateNode = null

@onready var interactable: Interactable = $InteractableGrave
@onready var fish_anchor: Node2D = $FishAnchor

var _fish_node = preload("res://nodes/grave/fish.tscn")
var _sm := OwnersGraveStateMachine.new()


func _ready() -> void:
	assert(game_state)

	interactable.sm = _sm
	_sm.player_bring_fish.connect(_place_fish)

func _input(event: InputEvent) -> void:
	if OS.is_debug_build():
		if event is InputEventMouseButton and event.is_pressed():
			var pos = get_global_mouse_position()
			var local_pos = to_local(pos)
			var rect = $Sprite.get_rect()

			if rect.has_point(local_pos):
				game_state.finished.emit("SleepState")


func _place_fish(collectable: CollectableData) -> void:
	var fish: Collectable = _fish_node.instantiate()

	assert(fish)

	fish.data = collectable

	fish_anchor.call_deferred("add_child", fish)

	game_state.finished.emit("SleepState")
