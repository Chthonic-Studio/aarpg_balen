class_name State_Walk extends State

@export var move_speed: float = 100.0 ## Base movement speed of the player

@onready var idle: State = $"../Idle"
@onready var attack: State = $"../Attack"


func _ready() -> void:
	pass

func init() -> void:
	pass
	
## What happens when the player enters the state
func Enter() -> void:
	player.UpdateAnimation("walk")

## What happens when the player exists the state
func Exit() -> void:
	pass

## What happens during the _process update in this state
func Process( _delta: float ) -> State:
	if player.direction == Vector2.ZERO:
		return idle
	
	player.velocity = player.direction * move_speed
	
	if player.SetDirection():
		player.UpdateAnimation("walk")
	
	return null

## What happens durings the _physics_update update in this state
func Physics( _delta: float ) -> State:
	return null	

## What happens during input events in this state
func HandleInput(_event: InputEvent) -> State:
	# Allow attacking even when walking
	if _event.is_action_pressed("left_attack"):
		return attack
	if _event.is_action_pressed("interact"):
		PlayerManager.interact_pressed.emit()
	return null
