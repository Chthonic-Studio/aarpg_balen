class_name HitBox extends Area2D

signal Damaged( hurt_box : HurtBox )


func _ready() -> void:
	pass

func TakeDamage( hurt_box : HurtBox ) -> void:
	print ("Damage taken: ", hurt_box.damage )
	Damaged.emit ( hurt_box )
