class_name Character

extends CharacterBody2D

var coinsCollected = 0

const Speed = 500.0
const Jump_velocity = -750
var GravityBoost = 2

@onready var Sprite_2d = $Sprite2D
@onready var Sprite_effect = $effect_spawn
@onready var Void_y = $"../Void_y"
@onready var SafeSpawn = $"../SafeSpawn"
@onready var Character = $"."

var hasEffect = false # disable respawn and other effects
var isKinematic = false # disable Input and movement animations

var canDoubleJump = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	Sprite_2d.play("Default")
	Sprite_effect.play("Spawn")
	hasEffect = false
	isKinematic = false
	canDoubleJump = true

func _physics_process(delta):
	if (not hasEffect && Character.transform.get_origin().y >= Void_y.transform.get_origin().y):
		Respawn()

	if (not isKinematic):
		# Running/Idle animation switch
		if ((velocity.x > 0 || velocity.x < -0) && (canDoubleJump || not Sprite_2d.is_playing())):
			Sprite_2d.animation = "Running"
		else:
			Sprite_2d.animation = "Default"

		# Jump
		if (Input.is_action_just_pressed("Jump") && is_on_floor()):
			velocity.y = Jump_velocity * 1.5
			Sprite_2d.animation = "Jumping"
			canDoubleJump = true
		# Double Jump
		elif (canDoubleJump && Input.is_action_just_pressed("Jump") && not is_on_floor()):
			velocity.y = Jump_velocity
			Sprite_2d.play("DoubleJumping")
			canDoubleJump = false

		# Direction y controller (gravity) + Jump/Fall animation switch
		if (not is_on_floor()):
			velocity.y += gravity * delta * GravityBoost
			if (velocity.y < 0 && (canDoubleJump || not Sprite_2d.is_playing())):
				Sprite_2d.animation = "Jumping"
			elif (canDoubleJump || not Sprite_2d.is_playing()):
				Sprite_2d.animation = "Falling"
		else:
			canDoubleJump = true

		# Direction x controller (Input) + Left/Right sprite_2d.flip_h switch
		var Direction = Input.get_axis("Left", "Right")
		var isLeft = Direction < 0
		if Direction:
			Sprite_2d.flip_h = isLeft
			velocity.x = Direction * Speed
		else:
			velocity.x = move_toward(velocity.x, 0, 15)

	#update
	move_and_slide()


# Respawn : disable.controllerXY/hide.Sprite_2d/anim.Despawn 2s tp.Character-SafeSpawn anim.Spawn/0.5s/enable.controllerXY
func Respawn():
	hasEffect = true
	isKinematic = true
	velocity = Vector2.ZERO
	Sprite_2d.animation = "Invisible"
	Sprite_effect.play("Despawn")
	
	await get_tree().create_timer(2.0).timeout
	
	Character.transform.origin = SafeSpawn.transform.get_origin()
	Sprite_2d.flip_h = false

	Sprite_effect.play("Spawn")
	await get_tree().create_timer(0.5).timeout
	Sprite_2d.play("Default")
	hasEffect = false
	isKinematic = false
