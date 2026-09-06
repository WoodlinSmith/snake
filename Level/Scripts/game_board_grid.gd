extends Node2D
const WHITE_CHECK = 0
const BLACK_CHECK = 1
const PLAYER_HEAD = 3
const PLAYER_TAIL = 4
const PLAYER_BODY = 5
const EMPTY = -1
const FOOD = 2

const UP = 1
const DOWN = 2
const LEFT = 3
const RIGHT = 4

const OFFSET = 64 #64px tiles
var tile_toggle = true
var grid_check = []
var grid_logic = []
var tile_scene = preload("res://Level/Scenes/tile.tscn")
var food_scene = preload("res://Food/Scenes/food.tscn")
var snake_head = preload("res://Player/Scenes/snake_head_base.tscn")
var snake_tail = preload("res://Player/Scenes/snake_tail_base.tscn")
var snake_body = preload("res://Player/Scenes/snake_body_base.tscn")

var max_food_spawned = false


#initial states for each component
var sh = null
var st = null
var sb = null
var fd = null 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid_init(9,9)
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
	set_player_location(length - 3, width - 3)
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
	grid_logic[y+1][x] = PLAYER_BODY
	grid_logic[y+2][x] = PLAYER_TAIL
	

func create_snake_body() -> void:
	for i in grid_logic.size():
		for j in grid_logic[i].size():
			if grid_logic[i][j] == PLAYER_HEAD:
				spawn_snake_part(PLAYER_HEAD,j,i)
			elif grid_logic[i][j] == PLAYER_TAIL:
				spawn_snake_part(PLAYER_TAIL,j,i)
			elif grid_logic[i][j] == PLAYER_BODY:
				spawn_snake_part(PLAYER_BODY,j,i)
	sh.connected_part = sb
	sb.connected_part = st
	
	
	
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
		add_child(st)
	elif part_code == PLAYER_BODY:
		sb = snake_body.instantiate()
		sb.global_position.x = OFFSET * offset_multiplier
		sb.global_position.y = OFFSET * row_multiplier
		sb.emit_direction.connect(_on_emit_direction, ConnectFlags.CONNECT_DEFERRED)
		sb._set_coords(Vector2i(offset_multiplier, row_multiplier))
		add_child(sb)

	
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
	try_spawn_food()
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
	
	
	
	if(grid_logic[part_coords_update.y][part_coords_update.x] == EMPTY
	or grid_logic[part_coords_update.y][part_coords_update.x] == FOOD):
		if(grid_logic[part_coords_update.y][part_coords_update.x] == FOOD
		and grid_logic[part_coords.y][part_coords.x] == PLAYER_HEAD):
			fd._on_eat()
			max_food_spawned = false
		grid_logic[part_coords_update.y][part_coords_update.x] = grid_logic[part_coords.y][part_coords.x]
		grid_logic[part_coords.y][part_coords.x] = EMPTY
	elif(grid_logic[part_coords_update.y][part_coords_update.x] != EMPTY
	and grid_logic[part_coords_update.y][part_coords_update.x] != FOOD
	and grid_logic[part_coords.y][part_coords.x] != PLAYER_HEAD):
		part_coords_update = part_coords
		grid_logic[part_coords.y][part_coords.x] = grid_logic[part_coords.y][part_coords.x]

	#calculate new position
	var new_pos = Vector2(part.global_position)
	if(dir == UP):
		if(part_coords_update.y != part_coords.y):
			new_pos.y = new_pos.y - OFFSET
		else:
			new_pos.y = new_pos.y

	elif(dir == DOWN):
		if(part_coords_update.y != part_coords.y):
			new_pos.y = new_pos.y + OFFSET
		else:
			new_pos.y = new_pos.y
	elif(dir == LEFT):
		if(part_coords_update.x != part_coords.x):
			new_pos.x = new_pos.x - OFFSET
		else:
			new_pos.x = new_pos.x
	elif (dir == RIGHT):
		if(part_coords_update.x != part_coords.x):
			new_pos.x = new_pos.x + OFFSET
		else:
			new_pos.x = new_pos.x
	
	var tween = create_tween()
	tween.tween_property(part,"global_position", new_pos, 1.0)
	part._set_coords(part_coords_update)
	if(OS.is_debug_build()):
		print_grid_to_console()
	
func print_grid_to_console() -> void:
	print("-------NEW TICK--------")
	for i in grid_logic.size():
		var print_list = []
		for j in grid_logic[i].size():
			print_list.append(grid_logic[i][j])
		print(print_list)
	print("-------END TICK--------")
	

func try_spawn_food() -> void:
	if not max_food_spawned:
		var row = randi_range(0, grid_logic.size()-1)
		var col = randi_range(0, grid_logic[0].size()-1)
		if(grid_logic[row][col] == EMPTY):
			grid_logic[row][col] = FOOD
			spawn_food(row, col)
			max_food_spawned = true
			
func spawn_food(row: int, col: int) -> void:
	var f = food_scene.instantiate()
	f.global_position.x = OFFSET * col
	f.global_position.y = OFFSET * row
	add_child(f)
	fd = f
	
