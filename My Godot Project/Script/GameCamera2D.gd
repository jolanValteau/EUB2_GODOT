extends Camera2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = lerp(position, Main.character.position, delta * 15)
	global_position.x = max(get_viewport().size.x/2+2, global_position.x)
	global_position.y = min(get_viewport().size.y/2, global_position.y)
