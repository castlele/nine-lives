extends TileMapLayer

@onready var opacityTimer: Timer = $opacity_timer
@onready var fireGhostOpacityLight: PointLight2D = $fire_ghost_light

var incrementOpacity = true
var isOpacityPaused = false

func _ready() -> void:
	var cells = get_used_cells()

	for cell in cells:
		var tileData = get_cell_tile_data(cell)
		incrementOpacity = not tileData.modulate.a >= 1

func _process(delta: float) -> void:
	var cells = get_used_cells()

	for cell in cells:
		var tileData = get_cell_tile_data(cell)

		if isOpacityPaused: continue

		if incrementOpacity:
			tileData.modulate.a += delta
			fireGhostOpacityLight.color.a += delta
		else:
			tileData.modulate.a -= delta
			fireGhostOpacityLight.color.a -= delta

		if tileData.modulate.a >= 1 and opacityTimer.is_stopped():
			incrementOpacity = false
			isOpacityPaused = true
			opacityTimer.start()

		if tileData.modulate.a <= 0 and opacityTimer.is_stopped():
			incrementOpacity = true
			isOpacityPaused = true
			opacityTimer.start()

func _on_opacity_timer_timeout() -> void:
	isOpacityPaused = false
