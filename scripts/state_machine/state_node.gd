class_name StateNode extends Node


@warning_ignore("unused_signal")
signal finished(new_state: StateNode, args: Variant)


@warning_ignore("unused_parameter")
func enter(args: Variant = null) -> void:
	pass


@warning_ignore("unused_parameter")
func process(delta: float) -> void:
	pass


func exit() -> void:
	pass
