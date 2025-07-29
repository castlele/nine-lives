extends Camera2D

func _process(delta: float) -> void:
	var player = get_parent().get_node("player")

	position = position.lerp(player.position, delta * 3)
