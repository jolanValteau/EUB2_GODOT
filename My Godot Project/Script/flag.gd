extends AnimatedSprite2D

@onready var sprite_2d = $"."
@onready var character = $"../Main_character"
const TriggerDistance = 100

func _ready():
	if (not sprite_2d.is_playing()):
		sprite_2d.play("Out")
	
	await get_tree().create_timer(2.0).timeout
	sprite_2d.animation = "Idle"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if (sprite_2d.get_global_transform().get_origin().distance_to(character.get_global_transform().get_origin()) < TriggerDistance):
		sprite_2d.play("In")
		await get_tree().create_timer(2.0).timeout
		sprite_2d.animation = "Default"


