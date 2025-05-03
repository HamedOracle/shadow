extends CharacterBody2D

# Player variables
var can_move := true
var is_dead := false

# Movement variables
var SPEED = 150.0
@export var walk_speed = 150.0
@export var run_speed = 250.0
@export_range(0, 1) var decelration = 0.1
@export_range(0, 1) var acceleration = 0.1
@export var jump_force = -400
@export_range(0, 1) var decel_on_jump_release = 0.5
@export var max_wall_jumps = 1  # Maximum number of wall jumps allowed
var wall_jump_count = 0  # Current number of wall jumps performed
@export var max_health = 100.0
var current_health : int = max_health


# Attack variables
var isAttacking = false
var secondAttack = false  # Tracks if the second attack is active
@onready var attack_timer = $attack1_timer
@onready var attack_1_limit = $attack1_limit
@onready var attack_2_limit = $attack2_limit
@onready var attack_2_timer = $attack2_timer

# Sprite and direction
@onready var animated_sprite = $AnimatedSprite2D
var last_direction: int = 1  # 1 for right, -1 for left

# Gravity
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



func _physics_process(delta):
	
	
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta


	# Handle jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			wall_jump_count = 0
			velocity.y = jump_force
		elif is_on_wall() and wall_jump_count < max_wall_jumps:
			wall_jump_count += 1
			velocity.y = jump_force

	# Handle jump height
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= decel_on_jump_release

	# Handle walk and run
	var speed
	if Input.is_action_pressed("run"):
		speed = run_speed
	else:
		speed = walk_speed

	# Handle direction
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, speed * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed * decelration)

	# Flip sprite based on direction
	if direction > 0:
		animated_sprite.flip_h = false
		last_direction = 1
	elif direction < 0:
		animated_sprite.flip_h = true
		last_direction = -1

	# Handle attacks
	if Input.is_action_just_pressed("attack btn") and not isAttacking and is_on_floor():
		isAttacking = true
		attack_timer.start()
		attack_1_limit.start()

	if not attack_2_limit.is_stopped() and Input.is_action_just_pressed("attack btn"):
		secondAttack = true

	# Movement during attacks
	if not isAttacking and direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	# Play animations
	if isAttacking and not secondAttack:
		animated_sprite.play("attack_1")
	elif isAttacking and secondAttack:
		animated_sprite.play("attack_2")
	elif not is_on_floor():
		animated_sprite.play("jump")
	elif is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("walk")

	# Apply movement
	move_and_slide()




# timer callbacks
func _on_attack_1_timer_timeout():
	if !secondAttack:
		isAttacking = false


func _on_attack_2_timer_timeout():
	secondAttack = false
	isAttacking = false
	
	
func _on_attack_1_limit_timeout():
	attack_2_limit.start()



func _on_attack_2_limit_timeout():
	if secondAttack:
		attack_2_timer.start()
		isAttacking = true
