class_name StateMachine extends Node


signal state_changed(current_state: StateNode)

@export var initial_state: StateNode

var _history_stack: Array[StateNode] = []
var _current_state: StateNode = null

var _states: Dictionary[String, StateNode] = {}


func _ready() -> void:
	for child in get_children():
		var state_node = child as StateNode

		_states[state_node.name] = state_node

		var err: bool = state_node.finished.connect(change_state)

		if err:
			printerr(err)

	change_state(initial_state)


func _process(delta: float) -> void:
	if _current_state:
		_current_state.process(delta)


func change_state(state: Variant) -> void:
	match typeof(state):
		TYPE_NIL:
			to_back_state()
		TYPE_STRING:
			_change_state(_states[state])
		_:
			_change_state(state)


func to_back_state() -> void:
	if _history_stack.size() == 0:
		print_debug("can't pop to previous state, history stack is empty")
		return

	_current_state.exit()

	var state = _history_stack.pop_back()

	if state and state is StateNode:
		print_debug("back to prev state: %s::%s" % [state.name, state])
		_current_state = state
		state_changed.emit(_current_state)


func _initialize() -> void:
	pass


func _change_state(state: StateNode) -> void:
	assert(state)
	assert(state is StateNode)
	print_debug("changing state to: %s::%s" % [state.name, state])

	if _current_state:
		_history_stack.append(_current_state)
		_current_state.exit()

	_current_state = state
	state_changed.emit(_current_state)
	_current_state.enter()
