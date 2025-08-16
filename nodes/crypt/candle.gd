@tool
extends Area2D

const CELL_SIZE = 32

enum CandleType {
	SMALL,
	DEFAULT,
	LARGE,
	MULTIPLE_ORANGE,
	MULTIPLE_PURPLE,
}


@export var candle_type = CandleType.DEFAULT

@onready var sprite: Sprite2D = $Sprite
@onready var light: PointLight2D = $Sprite/Light

var _is_player_around = false


func _ready() -> void:
	var rect = _get_candle_region()
	sprite.region_rect = rect
	sprite.offset.y = -1 * (rect.size.y/2 - 1)
	light.position = _get_light_pos()
	light.max_energy = _get_light_max_energy()


func _unhandled_key_input(event: InputEvent) -> void:
	if not _is_player_around:
		return

	if event is InputEventKey and event.is_action_pressed("interaction"):
		light.enabled = not light.enabled


func _on_body_entered(body: Node2D) -> void:
	assert(body is Player)
	_is_player_around = true


func _on_body_exited(body: Node2D) -> void:
	assert(body is Player)
	_is_player_around = false


func _get_candle_region() -> Rect2:
	var rect: Rect2

	match candle_type:
		CandleType.SMALL:
			rect = Rect2(CELL_SIZE, 0, CELL_SIZE, CELL_SIZE)
		CandleType.DEFAULT:
			rect = Rect2(0, 0, CELL_SIZE, CELL_SIZE*2)
		CandleType.LARGE:
			rect = Rect2(0, CELL_SIZE*2, CELL_SIZE, CELL_SIZE*2)
		CandleType.MULTIPLE_ORANGE:
			rect = Rect2(0, CELL_SIZE*4, CELL_SIZE, CELL_SIZE)
		CandleType.MULTIPLE_PURPLE:
			rect = Rect2(0, CELL_SIZE*5, CELL_SIZE, CELL_SIZE)

	return rect


func _get_light_pos() -> Vector2:
	var rect = _get_candle_region()

	return Vector2(0, -rect.size.y)


func _get_light_max_energy() -> float:
	var rect = _get_candle_region()
	var multiplier: float

	match candle_type:
		CandleType.SMALL:
			multiplier = 0.2
		CandleType.DEFAULT:
			multiplier = 0.5
		CandleType.LARGE:
			multiplier = 0.7
		CandleType.MULTIPLE_ORANGE, CandleType.MULTIPLE_PURPLE:
			multiplier = 0.3

	return (rect.size.x / rect.size.y) * 0.1 + multiplier
