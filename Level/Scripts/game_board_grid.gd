extends Node2D
const WHITE_CHECK = 0
const BLACK_CHECK = 1
const PLAYER_HEAD = 3
const PLAYER_TAIL = 4
const PLAYER_BODY = 5
const OFFSET = 64 #64px tiles
var tile_toggle = true
var grid = []
var tile_scene = preload("res://Level/Scenes/tile.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid_init(5,5)
	pass # Replace with function body.
	
func grid_init(length: int, width: int) -> void:
	for i in length:
		grid.append([])
		for j in width:
			if tile_toggle:
				grid[i].append(WHITE_CHECK)
			else:
				grid[i].append(BLACK_CHECK)
			tile_toggle = not tile_toggle
	create_display_objects()
	set_player_location(length - 2, width - 2)
	
func create_display_objects() -> void:
	for i in grid.size():
		for j in grid[i].size():
			if grid[i][j] == WHITE_CHECK:
				spawn_tile(WHITE_CHECK, j, i)	
			else:
				spawn_tile(BLACK_CHECK, j, i)
				
func set_player_location(x: int, y: int) -> void:
	grid[x][y] = PLAYER_HEAD
	grid[x+1][y] = PLAYER_TAIL

func spawn_tile(tile_type: int, offset_multiplier: int, row_multiplier: int) -> void:
	var t = tile_scene.instantiate()
	t.global_position.x = OFFSET * offset_multiplier
	t.global_position.y = OFFSET * row_multiplier
	add_child(t)
	t.set_base(tile_type)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_grid_tick_timeout() -> void:
	pass # Replace with function body.
