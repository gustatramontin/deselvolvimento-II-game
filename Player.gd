extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var PlayerData = PlayerDataClass.new()
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
		PlayerData.velocity.x += PlayerData.acceleration
		PlayerData.direction.x = 1		
	elif Input.is_action_pressed("move_left"):
		PlayerData.velocity.x -= PlayerData.acceleration
		PlayerData.direction.x = -1
	else:
		PlayerData.velocity.x = lerp(PlayerData.velocity.x, 0, 0.2)
	
	PlayerData.velocity.x = clamp(PlayerData.velocity.x,-PlayerData.stats.speed, PlayerData.stats.speed)
	
	$AnimatedSprite.flip_h = true if PlayerData.direction.x == -1 else false
	$ShootRay.cast_to.x = abs($ShootRay.cast_to.x) * PlayerData.direction.x
	PlayerData.velocity.y += PlayerData.gravity
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		PlayerData.velocity.y = -PlayerData.jump_force
	if Input.is_action_just_released("jump") and PlayerData.velocity.y < 0:
		PlayerData.velocity.y *= 0.5

	if Input.is_action_just_pressed("dash") and PlayerData.can_dash:
		PlayerData.dash = true
		PlayerData.can_dash = false 
	
	if PlayerData.dash:
		move_and_slide(PlayerData.velocity * 50, Vector2.UP)
		PlayerData.dash = false
		$DashTimer.start()
	
	if !PlayerData.hitted:
		PlayerData.velocity = move_and_slide(PlayerData.velocity, Vector2.UP)
	
	#PlayerData.velocity.x = lerp(PlayerData.velocity.x, 0 , 0.2)
	
	if Input.is_action_pressed("shoot"):
		$AnimatedSprite.play("shoot")
	else: 
		$AnimatedSprite.play("idle")
	if Input.is_action_pressed("shoot") and $ShootRay.is_colliding() and PlayerData.can_shoot:
		PlayerData.deal_damage($ShootRay.get_collider())
		$ShootTimer.start()
		
func take_damage():
	PlayerData.hitted = true
	PlayerData.take_damage(10)
	$DamageTimer.start()

func _on_DashTimer_timeout():
	PlayerData.can_dash = true


func _on_ShootTimer_timeout():
	PlayerData.can_shoot = true


func _on_DamageTimer_timeout():
	PlayerData.hitted = false
