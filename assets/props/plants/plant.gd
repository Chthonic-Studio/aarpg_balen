class_name Plant extends Node2D

func _ready():
	$HitBox.Damaged.connect ( TakeDamage )
	pass
	
func TakeDamage ( hurt_box : HurtBox ) -> void:
	print ("Plant took damage!")
	queue_free()
