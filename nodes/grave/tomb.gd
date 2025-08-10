extends StaticBody2D

@export var is_door_opened = false

@onready var open_door_area = $OpenDoor
@onready var open_door_sprite = $OpenDoor/Sprite
@onready var door_open_audio: AudioStreamPlayer = $DoorOpenAudio

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if not open_door_area.visible and is_door_opened:
		door_open_audio.play()
		await get_tree().create_timer(0.5).timeout
		Input.start_joy_vibration(0, 0.5, 0.5, 0.5)

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
		LevelStateMachine.load_scene(LevelStateMachine.Scene.CRYPT)


func update_door_state() -> void:
	open_door_area.visible = is_door_opened
