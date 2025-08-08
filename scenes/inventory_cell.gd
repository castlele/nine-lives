class_name InventoryCell extends Control


@onready var cell = $Cell
@onready var item = $Cell/Item


func update_inventory(item_data: CollectableData) -> void:
	if not item_data:
		item.texture = null
		return

	item.texture = item_data.image

	# TODO: Add scaling of the texture if needed
	item.transform.origin = _get_origin()


func _get_origin() -> Vector2:
	return cell.get_rect().get_center()
