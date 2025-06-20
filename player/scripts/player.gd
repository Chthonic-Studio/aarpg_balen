class_name Player extends CharacterBody2D

signal DirectionChanged ( new_direction: Vector2 )
signal player_damaged ( hurt_box : HurtBox )

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]
var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

var invulnerable : bool = false
var hp : int = 6
@export var max_hp : int = 6

@onready var sprite = $AnimatedSprite2D
@onready var effect_animation_player : AnimationPlayer = $EffectAnimationPlayer
@onready var state_machine : PlayerStateMachine = $StateMachine
@onready var hit_box : HitBox = $HitBox

@onready var collision = $CollisionShape2D


func _ready() -> void:
	PlayerManager.player = self
	state_machine.Initialize(self)
	hit_box.Damaged.connect( _take_damage )
	update_hp(99)
	pass
	
	
func _process( delta ):

	direction = Vector2 (
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	direction = direction.normalized()
	
	pass	

func _physics_process( delta ):
	move_and_slide()

func SetDirection() -> bool:
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int ( round( ( direction ).angle() / TAU * DIR_4.size() ) )
	var new_dir = DIR_4[ direction_id ]
		
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	DirectionChanged.emit( new_dir )
	return true
	
func UpdateAnimation( state : String ) -> void:
	sprite.play( state + "_" + AnimDirection())

func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	elif cardinal_direction == Vector2.LEFT:
		return "left"
	else:
		return "right"

func _take_damage( hurt_box : HurtBox ) -> void:
	print("_take_damage function on player triggered")
	if invulnerable == true:
		return
		
	update_hp( -hurt_box.damage )
	print("_take_damage generates " + str(hurt_box.damage) + " damage" )
	if hp > 0:
		player_damaged.emit( hurt_box )
		print("Emitting player_damaged as HP is above 0")
	else:
		player_damaged.emit( hurt_box )
		update_hp( 99 )
	pass
	
func update_hp( delta : int ) -> void:
	hp = clampi( hp + delta, 0, max_hp )
	print ("Player HP = " + str(hp))
	PlayerHud.update_hp( hp, max_hp)
	pass
	
func make_invulnerable( _duration : float = 1.0 ) -> void:
	invulnerable = true
	hit_box.monitoring = false
	
	await get_tree().create_timer( _duration ).timeout
	
	invulnerable = false
	hit_box.monitoring = true
