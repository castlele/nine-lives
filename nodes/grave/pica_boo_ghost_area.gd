extends Area2D

const MAX_Y = 50

@export var ghost_appearing_speed = 150
@export var light_appearing_speed = 15

@onready var sprite = $ghost_sprite

var ghost_hidden = false


func _process(delta: float) -> void:
	if ghost_hidden:
		if sprite.offset.y < MAX_Y:
			sprite.offset.y = Animator.fade(0, MAX_Y, delta * ghost_appearing_speed, sprite.offset.y)
			sprite.light.color.a = Animator.fade(1, 0, delta * light_appearing_speed, sprite.light.color.a)
	else:
		if sprite.offset.y > 0:
			sprite.offset.y = Animator.fade(MAX_Y, 0, delta * ghost_appearing_speed, sprite.offset.y)

		if sprite.offset.y <= MAX_Y/2.0:
			sprite.light.color.a = Animator.fade(0, 1, delta * light_appearing_speed, sprite.light.color.a)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		ghost_hidden = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		ghost_hidden = false
