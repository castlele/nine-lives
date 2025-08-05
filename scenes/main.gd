extends Control


@onready var main_screen_ui = $MainMenu
@onready var hud_ui = %HUD
@onready var root = %RootGameScene

var _level_scene: Node2D = null


func _ready() -> void:
	LevelStateMachine.current_level.connect(_load_level)
	LevelStateMachine.load_scene(LevelStateMachine.Scene.MAIN)


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if not _level_scene or not hud_ui.visible:
		return

	var rect = _level_scene.get_viewport_rect()
	hud_ui.size = rect.size
	hud_ui.position = rect.position



func _on_start_button_pressed() -> void:
	LevelStateMachine.load_scene(LevelStateMachine.Scene.GRAVE_YARD)


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _load_level(config: LevelConfig) -> void:
	_free_level()
	_apply_level_config(config)


func _apply_level_config(config: LevelConfig) -> void:
	main_screen_ui.visible = not config.main_hidden
	hud_ui.visible = not config.hud_hidden

	if not config.path.is_empty():
		_open_new_level(config.path)


func _open_new_level(level_path: String) -> void:
	assert(level_path)

	var level = load(level_path)

	assert(level)

	_level_scene = level.instantiate()

	root.call_deferred("add_child", _level_scene)


func _free_level() -> void:
	if _level_scene:
		_level_scene.queue_free()
		_level_scene = null
