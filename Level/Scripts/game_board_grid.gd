extends Node2D
const WHITE_CHECK = 0
const BLACK_CHECK = 1
const PLAYER_HEAD = 3
const PLAYER_TAIL = 4
const PLAYER_BODY = 5
const EMPTY = -1

const UP = 1
const DOWN = 2
const LEFT = 3
const RIGHT = 4

const OFFSET = 64 #64px tiles
var tile_toggle = true
var grid_check = []
var grid_logic = []
var tile_scene = preload("res://Level/Scenes/tile.tscn")
var snake_head = preload("res://Player/Scenes/snake_head_base.tscn")
var snake_tail = preload("res://Player/Scenes/snake_tail_base.tscn")
var snake_head_coords = null
var snake_head_coords_update = null

var sh = null
var st = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid_init(5,5)
	pass # Replace with function body.
	
func grid_init(length: int, width: int) -> void:
	for i in length:
		grid_check.append([])
		grid_logic.append([])
		for j in width:
			if tile_toggle:
				grid_check[i].append(WHITE_CHECK)
			else:
				grid_check[i].append(BLACK_CHECK)
			grid_logic[i].append(EMPTY)
			tile_toggle = not tile_toggle
	create_grid_board()
	set_player_location(length - 2, width - 2)
	create_snake_body()
	
func create_grid_board() -> void:
	for i in grid_check.size():
		for j in grid_check[i].size():
			if grid_check[i][j] == WHITE_CHECK:
				spawn_tile(WHITE_CHECK, j, i)	
			else:
				spawn_tile(BLACK_CHECK, j, i)
				
func set_player_location(y: int, x: int) -> void:
	grid_logic[y][x] = PLAYER_HEAD
	grid_logic[y+1][x] = PLAYER_TAIL
	snake_head_coords =  Vector2i(x,y)
	snake_head_coords_update = Vector2i(snake_head_coords)
	

func create_snake_body() -> void:
	for i in grid_logic.size():
		for j in grid_logic[i].size():
			if grid_logic[i][j] == PLAYER_HEAD:
				spawn_snake_part(PLAYER_HEAD,j, i)
			elif grid_logic[i][j] == PLAYER_TAIL:
				spawn_snake_part(PLAYER_TAIL,j,i)
	
	
	
func spawn_snake_part(part_code: int, offset_multiplier: int, row_multiplier: int) -> void:
	if part_code == PLAYER_HEAD:
		sh = snake_head.instantiate()
		sh.global_position.x = OFFSET * offset_multiplier
		sh.global_position.y = OFFSET * row_multiplier
		sh.emit_direction.connect(_on_emit_direction, ConnectFlags.CONNECT_DEFERRED)
		sh._set_coords(Vector2i(offset_multiplier,row_multiplier))
		add_child(sh)
	elif part_code == PLAYER_TAIL:
		st = snake_tail.instantiate()
		st.global_position.x =  OFFSET * offset_multiplier
		st.global_position.y =  OFFSET * row_multiplier
		st.emit_direction.connect(_on_emit_direction, ConnectFlags.CONNECT_DEFERRED)
		st._set_coords(Vector2i(offset_multiplier, row_multiplier))
		sh.connected_part = st
		add_child(st)

	
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
	sh._on_tick()
	pass # Replace with function body.
	
func _on_emit_direction(dir : int, part : Node2D, part_coords : Vector2i) -> void:
	#Need a better way to reference these as global constants
	var part_coords_update = Vector2i(part_coords)
	if(dir == UP):
		part_coords_update.y = part_coords.y - 1
	elif(dir == DOWN):
		part_coords_update.y = part_coords.y + 1
	elif(dir == LEFT):
		part_coords_update.x = part_coords.x - 1
	elif (dir == RIGHT):
		part_coords_update.x = part_coords.x + 1
		
	if(part_coords_update.y >= grid_logic.size()):
		part_coords_update.y = grid_logic.size() - 1
	if(part_coords_update.y < 0):
		part_coords_update.y = 0
	
	if(part_coords_update.x >= grid_logic[0].size()):
		part_coords_update.x = grid_logic.size() - 1
	if(part_coords_update.x < 0):
		part_coords_update.x = 0 
	
	
	grid_logic[part_coords_update.y][part_coords_update.x] = PLAYER_HEAD
	grid_logic[part_coords.y][part_coords.x] = EMPTY
	#calculate new position for snake_head
	var new_pos = Vector2(part.global_position)
	if(dir == UP):
		new_pos.y = new_pos.y - OFFSET
	elif(dir == DOWN):
		new_pos.y = new_pos.y + OFFSET
	elif(dir == LEFT):
		new_pos.x = new_pos.x - OFFSET
	elif (dir == RIGHT):
		new_pos.x = new_pos.x + OFFSET
	
	var tween = create_tween()
	tween.tween_property(part,"global_position", new_pos, 1.0)
	part._set_coords(part_coords_update)
	
