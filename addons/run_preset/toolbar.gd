@tool
extends Control


const config_path := 'res://.godot/editor/run_preset'


@onready var play_button: Button = %'Play Button'
@onready var config := ConfigFile.new()


var scene_path := ''


func init() -> void:
	if FileAccess.file_exists(config_path):
		set_scene_path(FileAccess.get_file_as_string(config_path).strip_edges())
	
	update_styles()
	theme_changed.connect(update_styles)


func update_styles() -> void:
	add_theme_stylebox_override('panel', get_theme_stylebox('LaunchPadNormal', 'EditorStyles'))


func set_scene_path(scene_path: String) -> void:
	if not FileAccess.file_exists(scene_path):
		scene_path = ''
	
	if self.scene_path == scene_path: return
	
	self.scene_path = scene_path
	
	if scene_path.is_empty():
		play_button.text = '<main>'
		play_button.tooltip_text = 'Run main scene'
	else:
		play_button.text = scene_path.get_file().trim_suffix('.' + scene_path.get_extension())
		play_button.tooltip_text = 'Run %s' % scene_path
	
	FileAccess.open(config_path, FileAccess.WRITE)\
		.store_string(scene_path)


func play() -> void:
	if not FileAccess.file_exists(scene_path):
		set_scene_path('')
	
	if scene_path.is_empty():
		EditorInterface.play_main_scene()
	else:
		EditorInterface.play_custom_scene(scene_path)


func edit() -> void:
	var current_scene := EditorInterface.get_edited_scene_root()
	if not current_scene: return
	set_scene_path(current_scene.scene_file_path)
