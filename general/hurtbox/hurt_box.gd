class_name HurtBox extends Area2D

@export var damage : int = 1
@export var rotates : bool = true

func _ready() -> void:
	area_entered.connect( AreaEntered )
	
	if get_parent() is Enemy:
		if rotates:
			var p = get_parent()
			var enemy: Enemy = null
			# Loop up the tree to find the Enemy node this hurtbox belongs to.
			while p:
				if p is Enemy:
					enemy = p
					break
				p = p.get_parent()
			
			if enemy:
				# Connect the signal and set the initial rotation based on the enemy's current direction.
				enemy.DirectionChanged.connect(_on_direction_changed)
				_on_direction_changed(enemy.cardinal_direction)

func AreaEntered( a : Area2D ) -> void:
	if a is HitBox:
		a.TakeDamage( self )

func _on_direction_changed(new_direction: Vector2) -> void:
	match new_direction:
		Vector2.DOWN:
			rotation_degrees = 0
		Vector2.UP:
			rotation_degrees = 180
		Vector2.LEFT:
			rotation_degrees = 90
		Vector2.RIGHT:
			rotation_degrees = -90
		_:
			rotation_degrees = 0

	
