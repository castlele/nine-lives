extends PointLight2D

@export var animation_duration = 0.2


func _ready() -> void:
	burn()


func burn() -> void:
	energy = randf() * 0.1 + 1.0
	scale = Vector2(1, 1) * energy

	await get_tree().create_timer(animation_duration).timeout

	burn()
