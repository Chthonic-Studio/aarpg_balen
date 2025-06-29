class_name Enemy extends CharacterBody2D

@export var hp : int = 3

signal DirectionChanged ( new_direction : Vector2 )
signal enemy_damaged ( hurt_box : HurtBox )
signal enemy_destroyed ( hurt_box : HurtBox )

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]
var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player : Player
var invulnerable : bool = false

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_box : HitBox = $HitBox
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine
@onready var PDH: PersistentDataHandler = $PersistentDataHandler
var destroyed : bool = false

func _ready() -> void:
	
	state_machine.Initialize( self )
	player = PlayerManager.player
	hit_box.Damaged.connect( _take_damage )
	PDH.data_loaded.connect( _set_state )
	_set_state()
	if destroyed:
		queue_free()

func _set_state() -> void:
	destroyed = PDH.value
	
func _process(_delta: float) -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	move_and_slide()

func SetDirection( _new_direction : Vector2 ) -> bool:
	direction = _new_direction
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
	if invulnerable == true:
		return
		
	hp -= hurt_box.damage
	if hp > 0:
		enemy_damaged.emit( hurt_box )
	else: 
		enemy_destroyed.emit( hurt_box )
