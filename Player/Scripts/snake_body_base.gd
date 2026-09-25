extends Node2D


signal emit_direction(code:int, head:Node2D, coords :Vector2i)
var curr_direction = DirectionConstants.UP
var prev_direction = DirectionConstants.UP

var connected_part = null
var is_valid = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _on_tick() -> void:
	if curr_direction == DirectionConstants.UP:
		$SnakeBodyTexture.rotation = deg_to_rad(0)
	elif curr_direction == DirectionConstants.DOWN:
		$SnakeBodyTexture.rotation = deg_to_rad(180)
	elif curr_direction == DirectionConstants.RIGHT:
		$SnakeBodyTexture.rotation = deg_to_rad(90)
	elif curr_direction == DirectionConstants.LEFT:
		$SnakeBodyTexture.rotation = deg_to_rad(270)
	emit_direction.emit(curr_direction, self, $Coords.coords)

	if is_valid:
		connected_part.curr_direction = prev_direction
		prev_direction = curr_direction
	connected_part._on_tick()
	
func _on_food(conn_part : Node2D) -> void:
	conn_part.connected_part = connected_part
	self.connected_part = conn_part
	
func _set_coords(coords : Vector2i) -> void:
	$Coords.coords = coords
