extends Camera2D

@onready var player = %Player

func _process(delta: float) -> void:
	position = position.lerp(player.position, delta * 3)
