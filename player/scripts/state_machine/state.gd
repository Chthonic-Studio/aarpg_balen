class_name State extends Node

static var player: Player
static var state_machine: PlayerStateMachine

func _ready() -> void:
	pass

func init() -> void:
	pass
	
## What happens when the player enters the state
func Enter() -> void:
	pass

## What happens when the player exists the state
func Exit() -> void:
	pass

## What happens during the _process update in this state
func Process( _delta: float ) -> State:
	return null

## What happens durings the _physics_update update in this state
func Physics( _delta: float ) -> State:
	return null	

## What happens during input events in this state
func HandleInput( _event: InputEvent ) -> State:
	return null
