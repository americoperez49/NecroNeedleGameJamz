@tool
extends EditorScript


# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	#var children:Array = get_editor_interface().get_selection().get_selected_nodes()[0].get_children()
	var mainNode:Node3D = 	get_scene()
	print(mainNode)

	for child in mainNode.get_children():
		if child is MeshInstance3D:	
			var body:StaticBody3D = StaticBody3D.new()
			get_scene().add_child(body,true)
			body.owner = get_scene()
			child.reparent(body)
			child.owner=get_scene()
			
			child.create_trimesh_collision()
			var collider = child.get_child(0).get_child(0)
			child.get_child(0).remove_child(collider)
			body.add_child(collider)
			collider.owner=get_scene()
			child.get_child(0).queue_free()
