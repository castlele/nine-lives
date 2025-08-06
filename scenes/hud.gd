extends Control


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if not visible:
		return

	if Input.is_action_just_pressed("ui_cancel"):
		_on_settings_button()


func _on_settings_button():
	LevelStateMachine.pause()
