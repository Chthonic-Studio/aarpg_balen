class_name ItemEffectHeal extends ItemEffect

@export var heal_amount : int = 1
@export var audio : AudioStream


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func use() -> void:
	PlayerManager.player.update_hp( heal_amount )
	PauseMenu.play_audio( audio )
