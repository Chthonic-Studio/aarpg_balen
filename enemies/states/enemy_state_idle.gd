class_name EnemyStateIdle extends EnemyState

@export var anim_name : String = "idle"

@export_category("AI")
@export var state_duration_min : float = 0.5
@export var state_duration_max : float = 2
@export var after_idle_state : EnemyState

var _timer : float = 0.0



func _init() -> void:
	pass

## What happens when the player enters the state
func enter() -> void:
	enemy.velocity = Vector2.ZERO
	_timer = randf_range( state_duration_min, state_duration_max )
	enemy.UpdateAnimation ( anim_name )
	pass

## What happens when the player exists the state
func exit() -> void:
	pass

## What happens during the _process update in this state
func process( _delta: float ) -> EnemyState:
	_timer -= _delta
	if _timer <= 0:
		return after_idle_state
	
	return null

## What happens durings the _physics_update update in this state
func physics( _delta: float ) -> EnemyState:
	return null	
