extends Node

var currentLevel = 1
@onready var Safe = $SafeSpawn
@onready var void_y = $Void_y
@onready var end = $End

@onready var Safe1 = $SafeSpawn
@onready var void_y1 = $Void_y
@onready var end1 = $End

@onready var Safe2 = $SafeSpawn
@onready var void_y2 = $Void_y
@onready var end2 = $End

func _ready():
	pass

func levelUp():
	currentLevel += 1
	
