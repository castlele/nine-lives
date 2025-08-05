extends Node2D


@onready var tomb = $tomb
@onready var message_box: MessageBox = $UI/MessageBox


func _ready() -> void:
	tomb.enter_tomb.connect(enter_next_level)


func enter_next_level() -> void:
	var level = load("res://scenes/crypt/crypt.tscn")

	get_tree().change_scene_to_packed(level)
