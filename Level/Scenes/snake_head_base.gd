extends Node2D

const UP = 1
const DOWN = 2
const LEFT = 3
const RIGHT = 4

signal emit_direction(code:int)
var curr_direction = UP

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("UP")):
		curr_direction = UP
	elif(Input.is_action_just_pressed("DOWN")):
		curr_direction = DOWN
	elif(Input.is_action_just_pressed("LEFT")):
		curr_direction = LEFT
	elif(Input.is_action_just_pressed("RIGHT")):
		curr_direction = RIGHT
	
func _on_tick() -> void:
	emit_direction.emit(curr_direction)
