extends Sprite2D

@onready var light = $ghost_light


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	light.offset = offset
