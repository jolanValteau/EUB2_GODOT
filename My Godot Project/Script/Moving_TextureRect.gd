extends TextureRect




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_parent().global_position = ((get_viewport().get_camera_2d().global_position) / 4)
