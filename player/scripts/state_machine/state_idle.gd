class_name State_Idle extends State

@onready var walk : State = $"../Walk"
@onready var attack: State = $"../Attack"


func _ready() -> void:
	pass
	
## What happens when the player enters the state
func Enter() -> void:
	player.UpdateAnimation("idle")
	pass

## What happens when the player exists the state
func Exit() -> void:
	pass

## What happens during the _process update in this state
func Process( _delta: float ) -> State:
	if player.direction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
	return null

## What happens durings the _physics_update update in this state
func Physics( _delta: float ) -> State:
	return null	

## What happens during input events in this state
func HandleInput( _event: InputEvent ) -> State:
	if _event.is_action_pressed("left_attack"):
		return attack
	return null
