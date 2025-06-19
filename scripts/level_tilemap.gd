class_name LevelTilemap extends TileMapLayer

func _ready() -> void:
	LevelManager.ChangeTilemapBounds( GetTilemapBounds() )
	
func GetTilemapBounds() -> Array [ Vector2 ]:
	var bounds : Array [ Vector2 ] = []
	bounds.append(
		Vector2( get_used_rect().position * tile_set.tile_size )
	)
	bounds.append(
		Vector2( get_used_rect().end * tile_set.tile_size )
	)
	return bounds
