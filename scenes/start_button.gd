extends Button


func _on_pressed() -> void:
	var level = load("res://scenes/grave_yard/grave_yard.tscn")

	get_tree().change_scene_to_packed(level)
