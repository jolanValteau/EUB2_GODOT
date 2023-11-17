extends Camera2D

@onready var end = $"../End"
@onready var void_y = $"../Void_y"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = lerp(position, Main.character.position, delta * 10)
	global_position.x = clamp(global_position.x, get_viewport().size.x/2+2, end.global_position.x - (get_viewport().size.x/2))
	global_position.y = clamp(global_position.y, -100000, void_y)
