class_name Plant extends Node2D

func _ready():
	$HitBox.Damaged.connect ( TakeDamage )
	pass
	
func TakeDamage ( _damage : int ) -> void:
	print ("Plant took damage!")
	queue_free()
