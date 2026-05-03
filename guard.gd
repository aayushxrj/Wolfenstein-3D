extends CharacterBody3D

#@onready var player : CharacterBody3D = get_tree().get_first_node_in_group("player")
var player : CharacterBody3D 

const SPEED = 5.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")  # Get the gravity from the project settings to be synced with RigidBody nodes.
var dead = false
var is_attacking = false  
var attack_range = 5

func _ready():
	add_to_group("enemy")

func _physics_process(delta):
	if dead or is_attacking:  # Check if the enemy is dead or attacking
		return

	if player == null:
		player = get_tree().get_first_node_in_group("player")
		return
		
	var dir = player.global_position - global_position
	dir.y = 0.0
	dir = dir.normalized()
	
	velocity = dir * SPEED
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	move_and_slide()
	
	if not is_attacking:
		if $AnimatedSprite3D.animation != "default":
			$AnimatedSprite3D.play("default")
			
	attack()

func attack():
	var dist_to_player = global_position.distance_to(player.global_position)
	if dist_to_player > attack_range:
		return
		#$AnimatedSprite3D.play("default")
	else:
		is_attacking = true  # Set the attacking flag
		$AnimatedSprite3D.play("shoot")
		await $AnimatedSprite3D.animation_finished  # Wait for the animation to finish
		is_attacking = false  # Reset the attacking flag


func die():
	dead = true  # Corrected variable scope
	$AnimatedSprite3D.play("die")
	$CollisionShape3D.disabled = true
