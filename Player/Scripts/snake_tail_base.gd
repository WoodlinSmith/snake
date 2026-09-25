extends Node2D


var curr_direction = DirectionConstants.UP
var is_valid = true
signal emit_direction(code:int, head:Node2D, coords :Vector2i)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_tick() -> void:
	if curr_direction == DirectionConstants.UP:
		$SnakeTailTexture.rotation = deg_to_rad(0)
	elif curr_direction == DirectionConstants.DOWN:
		$SnakeTailTexture.rotation = deg_to_rad(180)
	elif curr_direction == DirectionConstants.RIGHT:
		$SnakeTailTexture.rotation = deg_to_rad(90)
	elif curr_direction == DirectionConstants.LEFT:
		$SnakeTailTexture.rotation = deg_to_rad(270)
	emit_direction.emit(curr_direction, self, $Coords.coords)
	pass

func _set_coords(coords : Vector2i) -> void:
	$Coords.coords = coords
