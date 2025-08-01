extends Node2D

@onready var tomb = $tomb


func _ready() -> void:
	tomb.enter_tomb.connect(enter_next_level)


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass


func enter_next_level() -> void:
	var level = load("res://scenes/crypt/crypt.tscn")

	get_tree().change_scene_to_packed(level)
