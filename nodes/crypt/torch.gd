class_name Torch extends AnimatedSprite2D


@export var player_observer: RayCast2D = null

@onready var light: PointLight2D = $Light

var _is_player_around = false


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if not player_observer:
		return

	if player_observer.is_colliding():
		assert(player_observer.get_collider() is Player)
		_is_player_around = true
	else:
		_is_player_around = false


func _unhandled_input(event: InputEvent) -> void:
	if not _is_player_around:
		return

	if event is InputEventKey and event.is_action_pressed("interaction"):
		light.enabled = not light.enabled
