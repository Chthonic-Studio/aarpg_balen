class_name State_Attack extends State

@export var attack_sound : AudioStream ## Sound played when attacking
@export_range(1, 20, 0.5) var decelerate_speed : float = 5.0 ## The speed at which the player decelerates when attacking

@onready var walk : State = $"../Walk"
@onready var idle : State = $"../Idle"

@onready var animation : AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var audio : AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"


var attacking : bool = false

func _ready() -> void:
	pass
	
## What happens when the player enters the state
func Enter() -> void:
	player.UpdateAnimation("attack")
	animation.animation_finished.connect(EndAttack)
	
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
	attacking = true
	pass

## What happens when the player exists the state
func Exit() -> void:
	if animation.animation_finished.is_connected(EndAttack):
		animation.animation_finished.disconnect(EndAttack)
	attacking = false
	pass

## What happens during the _process update in this state
func Process( _delta: float ) -> State:

	player.velocity -= player.velocity * decelerate_speed * _delta
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else: 
			return walk
	return null

## What happens durings the _physics_update update in this state
func Physics( _delta: float ) -> State:
	return null	

## What happens during input events in this state
func HandleInput( _event: InputEvent ) -> State:
	
	return null
	
func EndAttack() -> void:
	attacking = false
