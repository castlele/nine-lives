# WARN: Deprecated, later should be updated with native Timer
class_name BlockingTimer extends Node


var _delay: float
var _message_timer: SceneTreeTimer


func _init(delay: float) -> void:
	_delay = delay


func runOnce(callable: Callable) -> void:
	if _is_blocking():
		return

	callable.call()

	_message_timer = get_tree().create_timer(_delay)
	await _message_timer.timeout


func _is_blocking() -> bool:
	return _message_timer != null and _message_timer.time_left != 0
