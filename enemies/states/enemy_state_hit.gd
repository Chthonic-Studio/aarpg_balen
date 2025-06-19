class_name EnemyStateHit extends EnemyState

@export var anim_name : String = "hit"
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0

@export_category("AI")
@export var next_state : EnemyState


var _direction : Vector2
var _animation_finished : bool = false

func init() -> void:
	enemy.enemy_damaged.connect( _on_enemy_damaged )
	pass

## What happens when the player enters the state
func enter() -> void:
	enemy.invulnerable = true
	_animation_finished = false
	
	_direction = enemy.global_position.direction_to( enemy.player.global_position )
	
	enemy.SetDirection( _direction )
	enemy.velocity = _direction * -knockback_speed
	
	enemy.UpdateAnimation( anim_name )
	enemy.sprite.animation_finished.connect( _on_animation_finished )

## What happens when the player exists the state
func exit() -> void:
	enemy.invulnerable = false
	enemy.sprite.animation_finished.disconnect( _on_animation_finished )
	pass

## What happens during the _process update in this state
func process( _delta: float ) -> EnemyState:
	
	if _animation_finished == true:
		
		return next_state
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null

## What happens durings the _physics_update update in this state
func physics( _delta: float ) -> EnemyState:
	return null	

func _on_enemy_damaged() -> void:
	state_machine.ChangeState( self )

func _on_animation_finished( ) -> void:
	_animation_finished = true
