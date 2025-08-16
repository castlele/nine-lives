class_name CryptDoor extends StaticBody2D


@export var is_door_opened: bool:
	get:
		return _is_door_opened
	set(new_value):
		_is_door_opened = new_value
		_update_door_state()

@onready var collider: CollisionShape2D = $Collider
@onready var entrence: NextLevelEntrence = $NextLevelEntrence

var _is_door_opened = false


func _ready() -> void:
	_update_door_state()


func _update_door_state() -> void:
	if entrence:
		entrence.monitoring = _is_door_opened
		collider.disabled = _is_door_opened
