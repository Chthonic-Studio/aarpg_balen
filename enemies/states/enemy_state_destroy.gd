class_name EnemyStateDestroy extends EnemyState

@export var anim_name : String = "destroy"
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0

@export_category("AI")

var _direction : Vector2
var _damage_position : Vector2

func init() -> void:
	enemy.enemy_destroyed.connect( _on_enemy_destroyed )
	pass

## What happens when the player enters the state
func enter() -> void:
	enemy.invulnerable = true
	
	_direction = enemy.global_position.direction_to( _damage_position )
	
	var knockback_direction : Vector2 = -_direction

	enemy.SetDirection( knockback_direction )
	enemy.velocity = _direction * -knockback_speed
	
	enemy.UpdateAnimation( anim_name )
	enemy.sprite.animation_finished.connect( _on_animation_finished )

## What happens when the player exists the state
func exit() -> void:
	pass

## What happens during the _process update in this state
func process( _delta: float ) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null

## What happens durings the _physics_update update in this state
func physics( _delta: float ) -> EnemyState:
	return null	

func _on_enemy_destroyed( hurt_box : HurtBox ) -> void:
	_damage_position = hurt_box.global_position
	state_machine.ChangeState( self )

func _on_animation_finished( ) -> void:
	enemy.queue_free()
