extends Camera2D

func _process(delta: float) -> void:
	var player = $player

	position = position.lerp(player.position, delta * 3)
