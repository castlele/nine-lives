class_name MessageBox extends MarginContainer

@export var message_delay = 0.3

@onready var text_box = $TextBox


var _message_queue: Array[String] = []
var _current_message = ""
var _timer: BlockingTimer


func set_queue(messages: Array[String]) -> void:
	_message_queue = messages
	_message_queue.reverse()


func is_empty() -> bool:
	return _message_queue.is_empty()


func _ready() -> void:
	_timer = BlockingTimer.new(message_delay)
	add_child(_timer)


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if not _message_queue.is_empty() and _current_message.is_empty():
		_show_message()

	_listen_input_events()


func _listen_input_events() -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_timer.run_once(_show_message)


func _show_message(event: InputEvent = null) -> void:
	if event != null and event is InputEventMouseButton and event.is_pressed():
		_dequeue()

	if event == null:
		_dequeue()


func _dequeue() -> void:
	var message = _message_queue.pop_back()

	if message:
		_current_message = message
	else:
		_current_message = ""

	print("setting text: " + _current_message)

	text_box.text = _current_message
