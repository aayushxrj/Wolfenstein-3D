extends Area3D

func _ready():
	pass
	
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		Global.ammo += 10
		print(Global.ammo)
		queue_free()
