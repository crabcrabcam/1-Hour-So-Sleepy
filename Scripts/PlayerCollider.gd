extends CollisionShape2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	connect("area_enter", self, "_on_enemy_body_enter")
	pass


func _on_Area2D_area_enter( area ):
	print("Trigger")
	get_tree().quit()
