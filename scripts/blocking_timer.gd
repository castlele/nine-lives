class_name BlockingTimer extends Node


var _delay: float
var _timer = Timer.new()


func _init(delay: float = 0.3) -> void:
	_delay = delay


func run_once(callable: Callable) -> void:
	if _is_blocking():
		return

	callable.call()

	_timer.start(_delay)
	await _timer.timeout


func _is_blocking() -> bool:
	return _timer.time_left != 0
