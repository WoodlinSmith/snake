extends CharacterBody2D


const SPEED = 100
const JUMP_VELOCITY = -400.0

var direction = "UP"
var player_input = "UP"


func _physics_process(delta: float) -> void:
	if(Input.is_action_just_pressed("UP")):
		player_input = "UP"
	elif(Input.is_action_just_pressed("DOWN")):
		player_input = "DOWN"
	elif(Input.is_action_just_pressed("LEFT")):
		player_input = "LEFT"
	elif(Input.is_action_just_pressed("RIGHT")):
		player_input = "RIGHT"
	
	match direction:
		"UP":
			velocity.y = -SPEED
			velocity.x = 0
		"DOWN":
			velocity.y = SPEED
			velocity.x = 0
		"LEFT":
			velocity.x = -SPEED
			velocity.y = 0
		"RIGHT":
			velocity.x = SPEED
			velocity.y = 0
	move_and_slide()


func _on_checkerboard_snake_entered() -> void:
	direction = player_input
	pass # Replace with function body.
