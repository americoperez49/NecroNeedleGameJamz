class_name HealthComponent
extends Node3D

@export var MAX_HEALTH:int
@export var health:int

# Called when the node enters the scene tree for the first time.
func _ready():
	health = MAX_HEALTH
	
#region DEBUG CODE TO TEST
	#await get_tree().create_timer(3).timeout
	#take_damage(4)
#endregion


func take_damage(damage_dealt)->void:
	health -= damage_dealt
	check_if_dead()
	
func check_if_dead():
	if health <=0:
		EventBus.died.emit(get_parent())
