class_name EnemyState extends Node

## Store references 

var enemy : Enemy
var state_machine : EnemyStateMachine

func init() -> void:
	pass

## What happens when the player enters the state
func enter() -> void:
	pass

## What happens when the player exists the state
func exit() -> void:
	pass

## What happens during the _process update in this state
func process( _delta: float ) -> EnemyState:
	return null

## What happens durings the _physics_update update in this state
func physics( _delta: float ) -> EnemyState:
	return null	
