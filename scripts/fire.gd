@tool
extends PointLight2D


@export var animation_duration = 0.2
@export var max_energy = 1.0


func _ready() -> void:
	burn()


func burn() -> void:
	if not get_tree():
		return

	energy = randf() * 0.1 + max_energy
	scale = Vector2(1, 1) * energy

	await get_tree().create_timer(animation_duration).timeout

	burn()
