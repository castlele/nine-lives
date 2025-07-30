extends Sprite2D

@onready var opacityTimer: Timer = $opacity_timer
@onready var fireGhostOpacityLight: PointLight2D = $fire_ghost_light

var incrementOpacity = true
var isOpacityPaused = false

func _ready() -> void:
	incrementOpacity = not modulate.a >= 1


func _process(delta: float) -> void:
	if isOpacityPaused: return

	if incrementOpacity:
		modulate.a += delta
		fireGhostOpacityLight.color.a += delta
	else:
		modulate.a -= delta
		fireGhostOpacityLight.color.a -= delta

	if modulate.a >= 1 and opacityTimer.is_stopped():
		incrementOpacity = false
		isOpacityPaused = true
		opacityTimer.start()

	if modulate.a <= 0 and opacityTimer.is_stopped():
		incrementOpacity = true
		isOpacityPaused = true
		opacityTimer.start()


func _on_opacity_timer_timeout() -> void:
	isOpacityPaused = false
