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
	if(texture_code == 0):
		base.texture = load("res://Level/Textures/white_tile_64.png")
	else:
		base.texture = load("res://Level/Textures/black_tile_64.png")
