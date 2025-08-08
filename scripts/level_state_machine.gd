extends Node


enum Scene {
	MAIN,
	GRAVE_YARD,
	CRYPT,
}


const INVENTORY_CAPACITY = 4

signal current_level(level)
signal message_queue(queue)
signal message_visible(visible)
signal inventory_update(items)

var _paused = false
var _config = LevelConfig.new()
var _inventory_items: Array[CollectableData] = []


func get_inventory() -> Array[CollectableData]:
	return _inventory_items.duplicate()


func add_inventory_item(item: CollectableData) -> bool:
	if len(_inventory_items) == INVENTORY_CAPACITY:
		return false

	var added = false

	for i in range(len(_inventory_items)):
		if _inventory_items[i]:
			continue

		_inventory_items[i] = item
		added = true

	if not added:
		_inventory_items.append(item)

	inventory_update.emit(_inventory_items)

	return true


func clear_inventory() -> void:
	for i in range(len(_inventory_items)):
		remove_inventory_item(i)


func remove_inventory_item(index: int) -> bool:
	if index < 0 || index > len(_inventory_items) - 1:
		return false

	_inventory_items[index] = null

	inventory_update.emit(_inventory_items)

	return true


func enqueue_messages(messages: Array[String]) -> void:
	message_queue.emit(messages)


func load_scene(level: Scene) -> void:
	_update_level_config(level)

	current_level.emit(_config)


func get_current_level_config() -> LevelConfig:
	return _config


func is_paused() -> bool:
	return _paused


func pause(value: bool = not is_paused()) -> void:
	_paused = value

	get_tree().paused = _paused


func _update_level_config(level: Scene):
	match level:
		Scene.MAIN:
			_config.path = ""
			_config.hud_hidden = true
			_config.main_hidden = false

		Scene.GRAVE_YARD:
			_config.path = "res://scenes/grave_yard/grave_yard.tscn"
			_config.hud_hidden = false
			_config.main_hidden = true
		Scene.CRYPT:
			_config.path = "res://scenes/crypt/crypt.tscn"
			_config.hud_hidden = false
			_config.main_hidden = true
