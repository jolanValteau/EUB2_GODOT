extends AnimatedSprite2D

var hasBeenCollected = false
const distanceTrigger = 100

func _ready():
	self.play("Default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (not hasBeenCollected && self.global_position.distance_to(Main.character.global_position) < distanceTrigger):
		self.animation = "Collected"
		hasBeenCollected = true
		Main.character.coinsCollected += 1
