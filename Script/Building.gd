extends Sprite2D
class_name Building

@export var hp = 1
@export var inhabitable = 1
@export var people : int = 1
var destroySprite : Texture2D

func destory():
	texture = destroySprite
func damage(power):
	hp -= power
	if(hp <= 0): destory()
