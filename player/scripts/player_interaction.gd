class_name PlayerInteractions extends Node2D

@onready var player : Player = $".."

func _ready() -> void:
	set_process_unhandled_input(true)
	player.DirectionChanged.connect ( UpdateDirection )
	pass

func UpdateDirection ( new_direction : Vector2  ) -> void:
	match new_direction:
		Vector2.DOWN:
			rotation_degrees = 0
		Vector2.UP:
			rotation_degrees = 180
		Vector2.LEFT:
			rotation_degrees = 90
		Vector2.RIGHT:
			rotation_degrees = -90
		_:
			rotation_degrees = 0
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		print("Interacted pressed")
		PlayerManager.interact_pressed.emit()
		get_viewport().set_input_as_handled()
