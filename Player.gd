extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 100
export var acceleration = 10
export var gravity = 300
var velocity = Vector2()
export var jump_force = 1
var hitted = false
var dash = false
var can_dash = true
var can_shoot = true
var direction = Vector2(1,1)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta):
	pass	
		
# increase speed sponentially
func acelleration(begin_speed, final_speed, frames):
	return pow(final_speed / begin_speed, 1.0/frames) 

func _physics_process(delta):
	
	velocity.x = clamp(velocity.x,-speed, speed)
	if Input.is_action_pressed("move_right"):
		velocity.x += acceleration
		direction.x = 1		
	elif Input.is_action_pressed("move_left"):
		velocity.x -= acceleration
		direction.x = -1
	else:
		velocity.x = lerp(velocity.x, 0, 0.2)
	
	$AnimatedSprite.flip_h = true if direction.x == -1 else false
	$ShootRay.cast_to.x = abs($ShootRay.cast_to.x) * direction.x
	velocity.y += gravity
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
		print("jump")
		
	if Input.is_action_just_pressed("dash") and can_dash:
		dash = true
		can_dash = false 
	
	if dash:
		move_and_slide(velocity * 50, Vector2.UP)
		dash = false
		$DashTimer.start()
	
	if !hitted:
		velocity = move_and_slide(velocity, Vector2.UP)
	
	velocity.x = lerp(velocity.x, 0 , 0.2)
	
	if Input.is_action_pressed("shoot"):
		$AnimatedSprite.play("shoot")
	else: 
		$AnimatedSprite.play("idle")
	if Input.is_action_pressed("shoot") and $ShootRay.is_colliding() and can_shoot:
		shoot()
		can_shoot = false
		$ShootTimer.start()
		
func take_damage():
	hitted = true
	$DamageTimer.start()

func shoot():
	$ShootRay.get_collider().take_damage(1)


func _on_DashTimer_timeout():
	can_dash = true


func _on_ShootTimer_timeout():
	can_shoot = true


func _on_DamageTimer_timeout():
	hitted = false
