extends Area2D


@export var data: CollectableData = null


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		_collect()


func _collect() -> void:
	assert(data)

	if LevelStateMachine.add_inventory_item(data):
		call_deferred("queue_free")
