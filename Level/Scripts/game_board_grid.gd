extends Node2D
const WHITE_CHECK = 0
const BLACK_CHECK = 1
const PLAYER_HEAD = 3
const PLAYER_TAIL = 4
const PLAYER_BODY = 5
var grid = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func grid_init(length: int, width: int) -> void:
	for i in length:
		grid.append([])
		for j in width:
			if j % 2 == 0:
				grid[i].append(WHITE_CHECK)
			else:
				grid[i].append(BLACK_CHECK)

func set_player_location(x: int, y: int) -> void:
	grid[x][y] = PLAYER_HEAD
	grid[x+1][y] = PLAYER_TAIL


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_grid_tick_timeout() -> void:
	pass # Replace with function body.
