extends Node2D


signal game_loss(final_score:int)
signal restart_game

var tile_toggle = true
var grid_check = []
var grid_logic = []
var tile_scene = preload("res://Level/Scenes/tile.tscn")
var food_scene = preload("res://Food/Scenes/food.tscn")
var snake_head = preload("res://Player/Scenes/snake_head_base.tscn")
var snake_tail = preload("res://Player/Scenes/snake_tail_base.tscn")
var snake_body = preload("res://Player/Scenes/snake_body_base.tscn")

var max_food_spawned = false

var game_over = false

var score = 0



#initial states for each component
var sh = null
var st = null
var sb = null
var fd = null 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_board()
	pass # Replace with function body.
	
func grid_init(length: int, width: int) -> void:
	for i in length:
		grid_check.append([])
		grid_logic.append([])
		for j in width:
			if tile_toggle:
				grid_check[i].append(CheckerboardConstants.WHITE_CHECK)
			else:
				grid_check[i].append(CheckerboardConstants.BLACK_CHECK)
			grid_logic[i].append(LogicConstants.EMPTY)
			tile_toggle = not tile_toggle
	create_grid_board()
	set_player_location(length - 3, width - 3)
	create_snake_body()
	
func create_grid_board() -> void:
	for i in grid_check.size():
		for j in grid_check[i].size():
			if grid_check[i][j] == CheckerboardConstants.WHITE_CHECK:
				spawn_tile(CheckerboardConstants.WHITE_CHECK, j, i)	
			else:
				spawn_tile(CheckerboardConstants.BLACK_CHECK, j, i)
				
func set_player_location(y: int, x: int) -> void:
	grid_logic[y][x] = LogicConstants.PLAYER_HEAD
	grid_logic[y+1][x] = LogicConstants.PLAYER_BODY
	grid_logic[y+2][x] = LogicConstants.PLAYER_TAIL
	

func create_snake_body() -> void:
	for i in grid_logic.size():
		for j in grid_logic[i].size():
			if grid_logic[i][j] == LogicConstants.PLAYER_HEAD:
				spawn_snake_part(LogicConstants.PLAYER_HEAD,j,i)
			elif grid_logic[i][j] == LogicConstants.PLAYER_TAIL:
				spawn_snake_part(LogicConstants.PLAYER_TAIL,j,i)
			elif grid_logic[i][j] == LogicConstants.PLAYER_BODY:
				spawn_snake_part(LogicConstants.PLAYER_BODY,j,i)
	sh.connected_part = sb
	sb.connected_part = st
	
	
	
func spawn_snake_part(part_code: int, offset_multiplier: int, row_multiplier: int) -> void:
	if part_code == LogicConstants.PLAYER_HEAD:
		sh = snake_head.instantiate()
		_init_snake_part(sh, offset_multiplier, row_multiplier)
	elif part_code == LogicConstants.PLAYER_TAIL:
		st = snake_tail.instantiate()
		_init_snake_part(st, offset_multiplier, row_multiplier)
	elif part_code == LogicConstants.PLAYER_BODY:
		sb = snake_body.instantiate()
		_init_snake_part(sb, offset_multiplier, row_multiplier)


func snake_eat_spawn(offset_multiplier: int, row_multiplier: int) -> void:
	var curr_bod = sb
	spawn_snake_part(LogicConstants.PLAYER_BODY, offset_multiplier, row_multiplier)
	sh.connected_part = sb
	sb.connected_part = curr_bod
	sb.curr_direction = curr_bod.curr_direction
	sb.prev_direction = curr_bod.prev_direction
func spawn_tile(tile_type: int, offset_multiplier: int, row_multiplier: int) -> void:
	var t = tile_scene.instantiate()
	t.global_position.x = CheckerboardConstants.OFFSET * offset_multiplier
	t.global_position.y = CheckerboardConstants.OFFSET * row_multiplier
	add_child(t)
	t.set_base(tile_type)


	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_grid_tick_timeout() -> void:
	if not game_over:
		sh._on_tick()
		try_spawn_food()
	if(OS.is_debug_build()):
		print_grid_to_console()
	pass # Replace with function body.

	
func _on_emit_direction(dir : int, part : Node2D, part_coords : Vector2i) -> void:
	var part_coords_update = Vector2i(part_coords)
	if(dir == DirectionConstants.UP):
		part_coords_update.y = part_coords.y - 1
	elif(dir == DirectionConstants.DOWN):
		part_coords_update.y = part_coords.y + 1
	elif(dir == DirectionConstants.LEFT):
		part_coords_update.x = part_coords.x - 1
	elif (dir == DirectionConstants.RIGHT):
		part_coords_update.x = part_coords.x + 1
		
	if(part_coords_update.y >= grid_logic.size()):
		part_coords_update.y = grid_logic.size() - 1
	if(part_coords_update.y < 0):
		part_coords_update.y = 0
	
	if(part_coords_update.x >= grid_logic[0].size()):
		part_coords_update.x = grid_logic.size() - 1
	if(part_coords_update.x < 0):
		part_coords_update.x = 0 
	
	part.is_valid = true
	var ate = false
	if(grid_logic[part_coords_update.y][part_coords_update.x] == LogicConstants.EMPTY
	or grid_logic[part_coords_update.y][part_coords_update.x] == LogicConstants.FOOD):
		if(grid_logic[part_coords_update.y][part_coords_update.x] == LogicConstants.FOOD
		and grid_logic[part_coords.y][part_coords.x] == LogicConstants.PLAYER_HEAD):
			ate = true
			fd._on_eat()
			max_food_spawned = false
			score += 1
		grid_logic[part_coords_update.y][part_coords_update.x] = grid_logic[part_coords.y][part_coords.x]
		grid_logic[part_coords.y][part_coords.x] = LogicConstants.EMPTY
	elif(grid_logic[part_coords_update.y][part_coords_update.x] != LogicConstants.EMPTY
	and grid_logic[part_coords_update.y][part_coords_update.x] != LogicConstants.FOOD):
		if grid_logic[part_coords.y][part_coords.x] != LogicConstants.PLAYER_HEAD:
			part_coords_update = part_coords
			grid_logic[part_coords.y][part_coords.x] = grid_logic[part_coords.y][part_coords.x]
			part.is_valid = false
		else:
			grid_logic[part_coords_update.y][part_coords_update.x] = grid_logic[part_coords.y][part_coords.x]
			grid_logic[part_coords.y][part_coords.x] = LogicConstants.EMPTY
			game_over = true
			game_loss.emit(score)
	
	if ate:
		grid_logic[part_coords.y][part_coords.x] = LogicConstants.PLAYER_BODY
		snake_eat_spawn(part_coords.x, part_coords.y)
	#calculate new position
	var new_pos = Vector2(part.global_position)
	if(dir == DirectionConstants.UP):
		if(part_coords_update.y != part_coords.y):
			new_pos.y = new_pos.y - CheckerboardConstants.OFFSET
		else:
			new_pos.y = new_pos.y

	elif(dir == DirectionConstants.DOWN):
		if(part_coords_update.y != part_coords.y):
			new_pos.y = new_pos.y + CheckerboardConstants.OFFSET
		else:
			new_pos.y = new_pos.y
	elif(dir == DirectionConstants.LEFT):
		if(part_coords_update.x != part_coords.x):
			new_pos.x = new_pos.x - CheckerboardConstants.OFFSET
		else:
			new_pos.x = new_pos.x
	elif (dir == DirectionConstants.RIGHT):
		if(part_coords_update.x != part_coords.x):
			new_pos.x = new_pos.x + CheckerboardConstants.OFFSET
		else:
			new_pos.x = new_pos.x
	
	var tween = create_tween()
	tween.tween_property(part,"global_position", new_pos, 1.0)
	part._set_coords(part_coords_update)

	
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
		if(grid_logic[row][col] == LogicConstants.EMPTY):
			grid_logic[row][col] = LogicConstants.FOOD
			spawn_food(row, col)
			max_food_spawned = true
			
func spawn_food(row: int, col: int) -> void:
	var f = food_scene.instantiate()
	f.global_position.x = CheckerboardConstants.OFFSET * col
	f.global_position.y = CheckerboardConstants.OFFSET * row
	add_child(f)
	fd = f
	


func _on_game_over_select_item_selected(index: int) -> void:
	if index == 0:
		restart_game.emit()
		_clear_children()
		_init_board()
		
		
	if index == 1:
		queue_free()
		get_tree().quit()
	pass # Replace with function body.
	
func _clear_children() -> void:
	for child in get_children():
		child.queue_free()
		
func _init_board() -> void:
		score = 0
		grid_logic = []
		grid_check = []
		sh = null
		sb = null
		fd = null
		st = null
		max_food_spawned = false
		game_over = false
		tile_toggle = true
		grid_init(9,9)
		
func _init_snake_part(sp : Node, offset_multiplier : int, row_multiplier : int) -> void:
	sp.global_position.x = CheckerboardConstants.OFFSET * offset_multiplier
	sp.global_position.y = CheckerboardConstants.OFFSET * row_multiplier
	sp.emit_direction.connect(_on_emit_direction, ConnectFlags.CONNECT_DEFERRED)
	sp._set_coords(Vector2i(offset_multiplier, row_multiplier))
	add_child(sp)
	
