class_name Rope extends StaticBody2D


@export var audio: AudioStream

@onready var audio_player = $AudioStreamPlayer2D


func _ready() -> void:
	audio_player.stream = audio


func play_audio() -> void:
	if audio_player.playing:
		audio_player.stop()

	audio_player.play()
