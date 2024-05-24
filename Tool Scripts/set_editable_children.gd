@tool
extends EditorScript


# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	var parent = get_editor_interface().get_selection().get_selected_nodes()[0]
	print(parent)
	var children:Array = parent.get_children()

	for child in children:
		var node:Node3D = child as Node3D
		print("before:",parent.is_editable_instance(node))
		parent.set_editable_instance(child,false)
		print("after:",parent.is_editable_instance(node))
			#body.owner = get_scene()
