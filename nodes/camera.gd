extends Camera2D

@export var target: Node2D = null

func _process(delta: float) -> void:
	if target:
		position = position.lerp(target.position, delta * 3)
