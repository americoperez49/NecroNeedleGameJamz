class_name HumanoidArm extends Node3D

# note: arm mesh must have same Skin resource assigned as the character body or bone weights wont work...
@export var _mesh:MeshInstance3D
@export var arm_kind:Humanoid.SOCKET_KIND
var _humanoid: Humanoid

func set_skeleton(humanoid: Humanoid, targetSkeleton: Skeleton3D):
	_humanoid = humanoid
	_mesh.skeleton = get_path_to(targetSkeleton)

func detach():
	_humanoid = null
	_mesh.skeleton = ""

# overridable hooks
func on_attached(): pass
func on_detached(): pass
