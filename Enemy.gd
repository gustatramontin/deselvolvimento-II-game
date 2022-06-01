extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var life = 100
var speed = 15
var velocity = Vector2(0,0)
var can_hit = true
onready var player = get_node("../Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func take_damage(amount):
	print("hit")
	life -= amount
	if life <= 0:
		queue_free()
func _physics_process(delta):
	var player_pos = player.position
	velocity.x =  1 if player_pos.x > position.x else -1 
	var collision = move_and_collide(velocity*speed*delta)
	
	if collision and can_hit:
		collision.collider.take_damage()
		$HitTimer.start()
		can_hit = false
		
	$LifeBar.value = life
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_HitTimer_timeout():
	can_hit = true
