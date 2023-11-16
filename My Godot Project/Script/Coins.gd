extends RichTextLabel

@onready var end = $"../End"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.text = "Coins : " + str(Main.character.coinsCollected)
	position = lerp(position, Main.character.position - get_viewport().size * 0.49, delta * 20)
	global_position.x = clamp(global_position.x, get_viewport().size.x/2+2, end.global_position.x - (get_viewport().size.x/2))
	global_position.y = 0
