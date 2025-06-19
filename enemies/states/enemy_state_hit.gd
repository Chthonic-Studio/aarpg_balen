class_name EnemyStateHit extends EnemyState

@export var anim_name : String = "hit"
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0
@export var hit_sound : AudioStream

@export_category("AI")
@export var next_state : EnemyState

@onready var audio : AudioStreamPlayer2D = $"../../AudioStreamPlayer2D"

var _direction : Vector2
var _animation_finished : bool = false
var _damage_position : Vector2

func init() -> void:
	enemy.enemy_damaged.connect( _on_enemy_damaged )
	pass

## What happens when the player enters the state
func enter() -> void:
	enemy.invulnerable = true
	_animation_finished = false
	
	audio.stream = hit_sound
	audio.pitch_scale = randf_range(0.8, 1.2)
	audio.play()
	
	_direction = enemy.global_position.direction_to( _damage_position )
	
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

func _on_enemy_damaged( hurt_box : HurtBox ) -> void:
	_damage_position = hurt_box.global_position
	state_machine.ChangeState( self )

func _on_animation_finished( ) -> void:
	_animation_finished = true
