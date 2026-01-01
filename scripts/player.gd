extends CharacterBody2D

const MOVEMENT = 700.0

var id: int = 0

var _thrust: float = 0.0

func _ready() -> void:
	add_to_group("players")

func _physics_process(delta):
	var angle: float = 0.0
	
	if Input.is_action_pressed("move_forward"):
		_thrust = MOVEMENT * delta
	if Input.is_action_pressed("move_backward"):
		_thrust = -MOVEMENT * delta * 0.25
	if Input.is_action_pressed("rotate_left"):
		angle = -2
	if Input.is_action_pressed("rotate_right"):
		angle = 2

	var rot = rotation_degrees

	var direction = Vector2(_thrust, 0).rotated(deg_to_rad(rot))
	move_and_collide(direction)
	
	rotate(deg_to_rad(angle))

	_thrust *= 0.99
