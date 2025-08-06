extends Node

enum Scene {
	MAIN,
	GRAVE_YARD,
	CRYPT,
}

signal current_level(level)
signal message_queue(queue)

var _paused = false
var _config = LevelConfig.new()


func enqueue_messages(messages: Array[String]) -> void:
	message_queue.emit(messages)


func load_scene(level: Scene) -> void:
	_update_level_config(level)

	current_level.emit(_config)


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
