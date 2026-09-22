extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_game_board_grid_game_loss(final_score: int) -> void:
	self.visible = true
	$GameOverMenu/ScoreCounter.text = "Final Score: %d" % final_score


func _on_game_board_grid_restart_game() -> void:
	self.visible = false
	$GameOverMenu/ScoreCounter.text = ""
	pass # Replace with function body.
