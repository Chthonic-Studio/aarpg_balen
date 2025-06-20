extends CanvasLayer

var hearts : Array[ HeartGUI ] = []


func _ready() -> void:
	for child in $Control/HFlowContainer.get_children():
		if child is HeartGUI:
			hearts.append( child )
			child.visible = false
	pass

func update_hp( _hp : int, _max_hp : int ) -> void:
	update_max_hp( _max_hp )
	
	var _heart_count : int = ceil( _max_hp / 4.0 )
	
	for i in _heart_count: 
		update_heart( i, _hp )

func update_heart ( _index : int, _hp : int  ) -> void:
	var _value : int = clamp( _hp - _index * 4, 0, 4 )
	hearts[ _index ].value = _value
	pass

func update_max_hp ( _max_hp : int ) -> void:
	
	var _heart_count : int = ceil(_max_hp / 4.0)

	for i in hearts.size():
		if i < _heart_count:
			hearts[i].visible = true
		else:
			hearts[i].visible = false
	pass
