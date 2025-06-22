extends CanvasLayer

signal shown
signal hidden

@onready var button_save : Button = $Control/VBoxContainer/Button_Save
@onready var button_load : Button = $Control/VBoxContainer/Button_Load
@onready var item_description: Label = $Control/ItemDescription
@onready var audio_stream: AudioStreamPlayer = $Control/AudioStreamPlayer
@onready var main_control: Control = $Control


var is_paused : bool = false

func _ready() -> void:
	hide_pause_menu()
	button_save.pressed.connect( _on_save_pressed )
	button_load.pressed.connect( _on_load_pressed )
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("pause"):
		if is_paused == false:
			show_pause_menu()
		else:
			hide_pause_menu()
		get_viewport().set_input_as_handled()

func show_pause_menu() -> void:
	get_tree().paused = true
	visible = true
	is_paused = true
	main_control.mouse_filter = Control.MOUSE_FILTER_STOP
	shown.emit()

func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false
	main_control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hidden.emit()

func _on_save_pressed() -> void:
	if is_paused == false:
		return
	SaveManager.save_game()
	hide_pause_menu()
	
func _on_load_pressed() -> void:
	if is_paused == false:
		return
	SaveManager.load_game()
	await LevelManager.level_load_started
	hide_pause_menu()

func update_item_description( new_text : String ) -> void:
	item_description.text = new_text

func play_audio( audio : AudioStream )-> void:
	audio_stream.stream = audio
	audio_stream.play()
