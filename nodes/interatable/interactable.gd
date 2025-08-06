class_name Interactable extends Area2D


@export var prefs = preload("res://nodes/interatable/interactable_pref.tres")

@onready var collider = $Collider

var is_player_around = false


func _ready() -> void:
	var circle = collider.shape as CircleShape2D

	circle.radius = prefs.radius
	circle.custom_solver_bias = prefs.custom_solver_bias


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		is_player_around = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		is_player_around = false
