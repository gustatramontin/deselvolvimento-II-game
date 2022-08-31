extends Node
class_name PlayerDataClass

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

var stats = {
	"life": 100,
	"speed": 100,
	"armor": 100,
	"strength": 10
}

func take_damage(amount):
	stats.life -= 10
	print("player hitted")
	if (stats.life <= 10):
		get_tree().quit()
		
func deal_damage(collider):
	collider.take_damage(stats.strength)
	can_shoot = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
