@tool
class_name Inventory extends HBoxContainer


@export var max_inventory := LevelStateMachine.INVENTORY_CAPACITY

var _cell = preload("res://scenes/inventory_cell.tscn")
var _cells: Array[InventoryCell] = []


func _ready() -> void:
	for i in range(max_inventory):
		_create_inventory_cell()

	LevelStateMachine.inventory_update.connect(_update_inventory)


func _create_inventory_cell():
	var cell_node = _cell.instantiate()

	add_child(cell_node)
	_cells.append(cell_node)


func _update_inventory(items_data: Array[CollectableData]) -> void:
	for i in range(len(items_data)):
		_cells[i].update_inventory(items_data[i])
