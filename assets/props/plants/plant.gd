class_name Plant extends Node2D

@onready var PDH: PersistentDataHandler = $PersistentDataHandler
var destroyed : bool = false

func _ready():
	$HitBox.Damaged.connect ( TakeDamage )
	_set_state()
	if destroyed == true:
		queue_free()
	pass
	
func TakeDamage ( hurt_box : HurtBox ) -> void:
	print ("Plant took damage!")
	destroyed = true
	PDH.set_value()
	queue_free()

func _set_state() -> void:
	destroyed = PDH.value
	
