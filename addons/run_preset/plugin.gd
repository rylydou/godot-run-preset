@tool
extends EditorPlugin


const Toolbar := preload('res://addons/run_preset/toolbar.gd')
const toolbar_scene := 'res://addons/run_preset/toolbar.tscn'


var toolbar: Toolbar


func _enter_tree() -> void:
	reload(false)


func _exit_tree() -> void:
	reload(true)


func reload(remove_only: bool) -> void:
	if is_instance_valid(toolbar):
		remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, toolbar)
		toolbar.free()
		toolbar = null
	
	if remove_only: return
	
	toolbar = load(toolbar_scene).instantiate()
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, toolbar)
	var container := toolbar.get_parent()
	container.move_child(toolbar, container.get_child_count() - 3)
	toolbar.init()
