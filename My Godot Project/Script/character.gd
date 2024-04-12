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

var canJump = true
var canDoubleJump = true
var canWallJump = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	Sprite_2d.play("Default")
	Sprite_effect.play("Spawn")
	hasEffect = false
	isKinematic = false
	canDoubleJump = true
	canJump = true
	canWallJump = true

func _physics_process(delta):
	if (not hasEffect && Character.transform.get_origin().y >= Void_y.transform.get_origin().y):
		Respawn()

	if (not isKinematic):
		# Running/Idle animation switch
		if (is_on_floor()):
			if ((velocity.x > 0 || velocity.x < -0)):
				Sprite_2d.animation = "Running"
			else:
				Sprite_2d.animation = "Default"

		if (Input.is_action_just_pressed("Jump")):
		# Jump
			if (canJump && canWallJump):
				canJump = false
				velocity.y = Jump_velocity * 1.5
				Sprite_2d.animation = "Jumping"
				canDoubleJump = true
			# Double Jump
			elif (canDoubleJump):
				canDoubleJump = false
				velocity.y = Jump_velocity
				Sprite_2d.play("DoubleJumping")
				# canJump = true # moon jump
			elif (not canWallJump && canJump):
				canJump = false
				canDoubleJump = false
				velocity.y = Jump_velocity * 1.5
				velocity.x = 100
				Sprite_2d.animation = "Jumping"

		# Direction y controller (gravity) + Jump/Fall animation switch
		if (not is_on_floor()):
			if (not canWallJump && canJump):
				velocity.y = 0
				Sprite_2d.animation = "WallJumping"
			else:
				velocity.y += gravity * delta * GravityBoost
			if (canDoubleJump || velocity.y > 0):
				if (velocity.y < 0): # Jump if going up ^
					Sprite_2d.animation = "Jumping"
				else: # else fall
					Sprite_2d.animation = "Falling"
		if (is_on_floor() && (  (canDoubleJump && velocity.y >= 0) || (not canDoubleJump && not canJump))  ):
			canJump = true
			canDoubleJump = false
			canWallJump = true
		if (is_on_wall() && canWallJump):
			canWallJump = false
			canJump = true
			canDoubleJump = false

		# Direction x controller (Input) + Left/Right sprite_2d.flip_h switch
		var Direction = Input.get_axis("Left", "Right")
		var isLeft = Direction < 0
		if (not (not canWallJump && canJump)):
			if Direction:
				Sprite_2d.flip_h = isLeft
				velocity.x = Direction * Speed
			else:
				velocity.x = move_toward(velocity.x, 0, delta * 2000)

	#update
	move_and_slide()


# Respawn : disable.controllerXY/hide.Sprite_2d/anim.Despawn 2s tp.Character-SafeSpawn anim.Spawn/0.5s/enable.controllerXY
func Respawn():
	hasEffect = true
	isKinematic = true
	canDoubleJump = true
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
