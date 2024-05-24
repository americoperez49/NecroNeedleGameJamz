extends CharacterBody3D

@export var nav_agent: NavigationAgent3D
const SPEED = 4
@export var player:Humanoid

func _physics_process(delta):
	velocity = Vector3.ZERO
	nav_agent.target_position = player.global_transform.origin
	var next_nav_point =  nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	move_and_slide()
	pass
