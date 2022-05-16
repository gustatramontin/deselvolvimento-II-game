extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 100
export var gravity = 300
var velocity = Vector2()
export var jump_force = 400
var moving = false
var dash = false
var can_dash = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta):
	pass	
		
# increase speed sponentially
func acelleration(begin_speed, final_speed, frames):
	return pow(final_speed / begin_speed, 1.0/frames) 

func _physics_process(delta):
	
	if Input.is_action_pressed("move_right"):
		velocity.x = speed

	elif Input.is_action_pressed("move_left"):
		velocity.x = -speed
	
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
		
	velocity = move_and_slide(velocity, Vector2.UP)
	
	velocity.x = lerp(velocity.x, 0 , 0.2)


func _on_DashTimer_timeout():
	can_dash = true
