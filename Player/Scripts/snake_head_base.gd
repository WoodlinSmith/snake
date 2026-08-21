extends Node2D

const UP = 1
const DOWN = 2
const LEFT = 3
const RIGHT = 4

signal emit_direction(code:int, head:Node2D, coords :Vector2i)
var curr_direction = UP
var prev_direction = UP

var grid_coords = null
var connected_part = null




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
	if curr_direction == UP:
		$SnakeHeadTexture.rotation = deg_to_rad(0)
	elif curr_direction == DOWN:
		$SnakeHeadTexture.rotation = deg_to_rad(180)
	elif curr_direction == RIGHT:
		$SnakeHeadTexture.rotation = deg_to_rad(90)
	elif curr_direction == LEFT:
		$SnakeHeadTexture.rotation = deg_to_rad(270)
	emit_direction.emit(curr_direction, self, $Coords.coords)
	connected_part.curr_direction = prev_direction
	prev_direction = curr_direction
	connected_part._on_tick()
	
func _set_coords(coords : Vector2i) -> void:
	$Coords.coords = coords
