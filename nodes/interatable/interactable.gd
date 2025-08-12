@tool
class_name Interactable extends Area2D


@export var prefs: InteractablePref
@export var player: Player = null

@onready var collider: CollisionShape2D = $Collider

var _is_player_around = false


func _ready() -> void:
	var capsule = CapsuleShape2D.new()
	
	capsule.radius = prefs.radius
	capsule.height = prefs.height
	collider.shape = capsule
	
	collider.rotation_degrees = prefs.rotation_angle


func _unhandled_input(event: InputEvent) -> void:
	if not _is_player_around:
		return

	if event is InputEventKey and event.is_action_pressed("interaction"):
		_interact_with_player()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		_is_player_around = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		_is_player_around = false


func _interact_with_player() -> void:
	pass
