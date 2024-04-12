extends Node

var currentLevel = 1
@onready var Safe = $SafeSpawn
@onready var void_y = $Void_y
@onready var end = $End

@onready var Safe1 = $levels/SafeSpawn1
@onready var void_y1 = $levels/Void_y1
@onready var end1 = $levels/End1

@onready var Safe2 = $levels/SafeSpawn2
@onready var void_y2 = $levels/Void_y2
@onready var end2 = $levels/End2

@onready var bg = $camPoint/MovingCamera/TextureRect
@onready var flag = $Flag

func _ready():
	Safe.global_position = Safe1.global_position
	void_y.global_position = void_y1.global_position
	end.global_position = end1.global_position

func levelUp():
	currentLevel += 1
	if (currentLevel == 2):                   
		Safe.global_position = Safe2.global_position
		void_y.global_position = void_y2.global_position
		end.global_position = end2.global_position
	flag.hasBeenCollected = false
	flag._ready()
	flag.global_position = end.global_position
	flag.global_position.x -= 50
	flag.global_position.y -= 60
	bg.resetBG()
