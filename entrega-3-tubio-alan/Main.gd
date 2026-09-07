extends Node

@onready var player: Node2D = $Player

func _ready() -> void:
	randomize()
	player.initialize(self)
