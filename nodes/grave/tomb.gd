extends StaticBody2D

@export var is_door_opened = false

signal enter_tomb

@onready var open_door_area = $OpenDoor
@onready var open_door_sprite = $OpenDoor/Sprite

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	update_door_state()


func _input(event: InputEvent) -> void:
	if OS.is_debug_build():
		if event is InputEventMouseButton and event.is_pressed():
			var pos = get_global_mouse_position()
			var localPos = open_door_sprite.to_local(pos)
			var rect = open_door_sprite.get_rect()

			is_door_opened = rect.has_point(localPos)


func _on_open_door_body_entered(body: Node2D) -> void:
	if not is_door_opened:
		return

	if body is Player:
		enter_tomb.emit()


func open_door() -> void:
	is_door_opened = true


func update_door_state() -> void:
	open_door_area.visible = is_door_opened
