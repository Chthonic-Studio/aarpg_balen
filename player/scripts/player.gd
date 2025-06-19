class_name Player extends CharacterBody2D

signal DirectionChanged ( new_direction: Vector2 )

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]
var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

@onready var animation_player = $AnimatedSprite2D
@onready var sprite = $AnimatedSprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine

@onready var collision = $CollisionShape2D



func _ready() -> void:
	PlayerManager.player = self
	state_machine.Initialize(self)
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
	animation_player.play( state + "_" + AnimDirection())

func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	elif cardinal_direction == Vector2.LEFT:
		return "left"
	else:
		return "right"
