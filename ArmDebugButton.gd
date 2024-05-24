extends Button

@export var player:Humanoid
@export var arm_prefab: PackedScene

var _arm_prefab_loaded

# Called when the node enters the scene tree for the first time.
func _ready():
	load("")

func _on_pressed():
	var arm_node = arm_prefab.instantiate()
	var arm = arm_node as HumanoidArm
	if not arm:
		push_error("arm prefab must have HumanoidArm on the root node!")
		return
	
	player.attach_arm(arm, arm.arm_kind)
