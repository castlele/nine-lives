@tool
class_name Inventory extends HBoxContainer


@export var max_inventory := 4

var _cell = preload("res://scenes/inventory_cell.tscn")


func _ready() -> void:
	for i in range(max_inventory):
		_create_inventory_cell()


func _create_inventory_cell():
	var cell_node = _cell.instantiate()
	add_child(cell_node)
