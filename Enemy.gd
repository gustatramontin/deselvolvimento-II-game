extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var life = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func take_damage():
	print("hit")
	life -= 20
	if life <= 0:
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
