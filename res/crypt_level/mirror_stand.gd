extends Node2D


var _mirror := preload("res://scenes/crypt/mirror.tscn")

var _is_player_around = false


func _input(event: InputEvent) -> void:
	if not (event is InputEventKey):
		return

	if event.is_action_pressed("interaction") and LevelStateMachine.is_in_inventory("mirror"):
		var mirror_node = _mirror.instantiate()
		mirror_node.data = LevelStateMachine.get_inventory_item("mirror")
		mirror_node.data.interactable = false

		add_child(mirror_node)
		mirror_node.visible = true


func _on_area_body_entered(body: Node2D) -> void:
	assert(body is Player)
	_is_player_around = true


func _on_area_body_exited(body: Node2D) -> void:
	assert(body is Player)
	_is_player_around = false
