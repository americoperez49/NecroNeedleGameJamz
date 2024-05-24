class_name Humanoid extends CharacterBody3D
@export var spring_arm_pivot:Node3D
@export var spring_arm:SpringArm3D
@export var metarig:Node3D
@export var skeleton:Skeleton3D
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const LERP_VAL =.15
var mouse_captured:bool = false
var left_arm: HumanoidArm
var right_arm: HumanoidArm

# can only change mouse capture mode in _input callbacks on web platform!
var is_first_input: bool = true


enum SOCKET_KIND {LEFT_ARM, RIGHT_ARM}


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _input(event):
	if is_first_input and event is InputEventMouseMotion:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		mouse_captured = true
		is_first_input = false
		
	if mouse_captured and event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x * .005)
		spring_arm.rotate_x(-event.relative.y * .005)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)
		
	if event.is_action_pressed("ui_cancel"):
		if mouse_captured:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			mouse_captured = false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			mouse_captured = true


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP,spring_arm_pivot.rotation.y)
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		metarig.rotation.y =lerp_angle(metarig.rotation.y, atan2(-velocity.x,-velocity.z),LERP_VAL)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()



func attach_arm(newArm: HumanoidArm, destinationSocket: SOCKET_KIND):
	match destinationSocket:
		SOCKET_KIND.LEFT_ARM:
			try_detach_arm(left_arm)
		SOCKET_KIND.RIGHT_ARM:
			try_detach_arm(right_arm)
		_: push_error("handler not implemented for this kind of socket")
	
	# set new arm node's parent and skeleton; we reset the transform value to identity to undo any local transformations
	skeleton.add_child(newArm)
	newArm.transform.origin = Vector3.ZERO
	newArm.rotation = Vector3.ZERO
	newArm.scale = Vector3.ONE
	
	newArm.set_skeleton(self, skeleton)
	newArm.on_attached()



func try_detach_arm(arm: HumanoidArm):
	if arm:
		arm.detach()
		skeleton.remove_child(arm)
		arm.on_detached()
