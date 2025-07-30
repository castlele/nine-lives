extends Sprite2D

@onready var light = $ghost_light


func _process(delta: float) -> void:
	light.offset = offset
