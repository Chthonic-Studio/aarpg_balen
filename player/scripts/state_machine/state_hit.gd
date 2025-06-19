class_name StateHit extends State

@export var knockback_speed : float = 100.0
@export var decelerate_speed : float = 10.0
@export var invulnerable_duration : float = 1.0

var hurt_box : HurtBox
var direction : Vector2

var next_state : State = null

@onready var idle: State = $"../Idle"


func _ready() -> void:
	pass

func init() -> void:
	player.player_damaged.connect( _player_damaged )
	
## What happens when the player enters the state
func Enter() -> void:
	player.UpdateAnimation( "hit" )
	player.sprite.animation_finished.connect( _animation_finished )
	
	direction = player.global_position.direction_to( hurt_box.global_position )
	player.velocity = direction * -knockback_speed
	player.SetDirection()
	
	player.make_invulnerable( invulnerable_duration )
	player.effect_animation_player.play("damaged")

## What happens when the player exists the state
func Exit() -> void:
	next_state = null
	player.sprite.animation_finished.disconnect( _animation_finished )
	pass

## What happens during the _process update in this state
func Process( _delta: float ) -> State:
	
	return next_state

## What happens durings the _physics_update update in this state
func Physics( _delta: float ) -> State:
	return null	

## What happens during input events in this state
func HandleInput(_event: InputEvent) -> State:
	return null

func _player_damaged( _hurt_box : HurtBox ) -> void:
	hurt_box = _hurt_box
	state_machine.ChangeState( self )

func _animation_finished( _a: String) -> void:
	next_state = idle
