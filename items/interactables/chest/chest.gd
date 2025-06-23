class_name Chest extends Node2D

@export var open_sound: AudioStream
@export var close_sound: AudioStream
@export var items: Array[DropData]

@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var interact_area: Area2D = $InteractArea
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var PDH: PersistentDataHandler = $PersistentDataHandler


var is_open: bool = false # Is the chest currently in the open state?
var player_in_area: bool = false # Is the player currently in the interaction zone?
var has_been_opened: bool = false # Has the chest been opened at least once? Prevents re-looting.
var items_given: Array[Dictionary] = [] # A temporary list of items given, for the label animation.


func _ready() -> void:
	interact_area.area_entered.connect(_on_body_entered)
	interact_area.area_exited.connect(_on_body_exited)
	
	PDH.data_loaded.connect( set_chest_state )
	set_chest_state()

func set_chest_state() -> void:
	has_been_opened = PDH.value

func _process(_delta: float) -> void:
	if is_open and not player_in_area:
		is_open = false
		sprite.play("close")
		if close_sound:
			audio_stream_player.stream = close_sound
			audio_stream_player.play()

## This function should be called by the player when they interact with the chest.
func interact() -> void:
	if is_open or not player_in_area:
		return # Do nothing if the chest is already open or player is not in range.

	is_open = true
	PDH.set_value()
	sprite.play("open")

	if open_sound:
		audio_stream_player.stream = open_sound
		audio_stream_player.pitch_scale = randf_range(0.9, 1.1)
		audio_stream_player.play()

	# Only give items if the chest has not been opened before.
	if not has_been_opened:
		has_been_opened = true # Mark as opened to prevent giving items again.
		if items.size() > 0:
			_prepare_and_give_items()
			_show_item_labels()
			items.clear() # Empty the chest's inventory so it can't be re-looted.
		else:
			printerr("No items in Chest! Chest Name: ", name)


func _prepare_and_give_items() -> void:
	items_given.clear()
	for drop_data in items:
		if drop_data and drop_data.item:
			var quantity = drop_data.get_drop_count()
			if quantity > 0:
				items_given.append({"item": drop_data.item, "quantity": quantity})
				PlayerManager.INVENTORY_DATA.add_item(drop_data.item, quantity)


func _show_item_labels() -> void:
	call_deferred("_animate_labels")


func _animate_labels() -> void:
	# Set the starting position for the labels to appear above the chest.
	var start_pos = global_position - Vector2(0, 32)
	for i in items_given.size():
		var item_drop = items_given[i]

		var new_label := Label.new()
		new_label.text = item_drop.item.name + " x" + str(item_drop.quantity)
		
		# Make the label invisible initially by setting its alpha to 0.
		new_label.modulate.a = 0.0
		
		# Add the label to the main scene tree so it's not affected by the chest's position.
		get_tree().current_scene.add_child(new_label)
		new_label.global_position = start_pos - Vector2(0, i * 18)

		# Tween for fading in and out.
		var fade_tween = create_tween()
		fade_tween.tween_property(new_label, "modulate:a", 1.0, 0.3) # Fade in
		fade_tween.tween_interval(1.0) # Wait
		fade_tween.tween_property(new_label, "modulate:a", 0.0, 0.5) # Fade out
		fade_tween.tween_callback(new_label.queue_free) # Remove label when done.

		# Tween for moving the label up, runs in parallel to the fade animation.
		var move_tween = create_tween()
		var total_duration = 0.3 + 1.0 + 0.5 # Total duration of the fade tween.
		move_tween.tween_property(new_label, "global_position:y", new_label.global_position.y - 20, total_duration)

		# Wait briefly before displaying the next item label.
		await get_tree().create_timer(0.3).timeout


func _on_body_entered(area: Area2D) -> void:
	# We must check if the body that entered is actually the Player.
	if area.get_owner() is Player:
		player_in_area = true # Mark that the player is in range.
		PlayerManager.interact_pressed.connect( interact )
		print("Player entering interact area of chest ", name)


func _on_body_exited(area: Area2D) -> void:
	if area.get_owner() is Player:
		player_in_area = false # Mark that the player has left.
		if PlayerManager.interact_pressed.is_connected(interact):
			PlayerManager.interact_pressed.disconnect(interact)
