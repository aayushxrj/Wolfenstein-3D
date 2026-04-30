extends CanvasLayer

var ammo = 0
var current_weapon = "knife"

func _ready():
	$AnimatedSprite2D.animation_finished.connect(_on_AnimatedSprite2D_animation_finished)

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		if current_weapon == "knife":
			$AnimatedSprite2D.play("stab")
		elif current_weapon == "gun":
			if ammo > 0:
				$AnimatedSprite2D.play("shoot")
				ammo -= 1

func _on_AnimatedSprite2D_animation_finished():
	if current_weapon == "knife":
		$AnimatedSprite2D.play("knife_idle")
	elif current_weapon == "gun":
		$AnimatedSprite2D.play("gun_idle")
