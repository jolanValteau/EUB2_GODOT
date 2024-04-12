extends TextureRect

@onready var camPoint = $"../.."
@onready var cam = $"../../../Camera2D"
@onready var moveCam = $".."
@onready var start = $"../../../SafeSpawn"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	moveCam.global_position = cam.global_position / 4
	moveCam.global_position.y = camPoint.global_position.y

func resetBG():
	camPoint.global_position = start.global_position
