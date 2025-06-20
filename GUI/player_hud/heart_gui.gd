class_name HeartGUI extends Control

@onready var sprite : Sprite2D = $Sprite2D

var value : int = 4 :
	set ( _value ):
		value = _value
		update_sprite()

func update_sprite() -> void:
	sprite.frame = 4 - value
