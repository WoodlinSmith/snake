extends Node2D

@onready var base = $BaseTileTexture
@onready var top = $TopLayerTexture
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func set_base(texture_code: int) -> void:
	
	match texture_code:
		0:
			base.texture = load("res://Level/Textures/dirt_tile_64.png")
		1:
			base.texture = load("res://Level/Textures/top_tile_64.png")
		2:
			base.texture = load('res://Level/Textures/bottom_tile_64.png')
		3:
			base.texture = load('res://Level/Textures/left_edge_tile_64.png')
		4:
			base.texture = load('res://Level/Textures/right_edge_tile_64.png')
		5: 
			base.texture = load('res://Level/Textures/top_left_tile_64.png')
		6:
			base.texture = load('res://Level/Textures/top_right_tile_64.png')
		7:
			base.texture = load('res://Level/Textures/bottom_left_tile_64.png')
		8:
			base.texture = load('res://Level/Textures/bottom_right_tile_64.png')
		_:
			base.texture = load("res://Level/Textures/black_tile_64.png")
