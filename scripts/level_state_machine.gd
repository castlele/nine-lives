extends Node

enum Scene {
	MAIN,
	GRAVE_YARD,
	CRYPT,
}

signal current_level(level)

var _config = LevelConfig.new()


func load_scene(level: Scene) -> void:
	_update_level_config(level)

	current_level.emit(_config)


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
