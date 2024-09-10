extends Sprite2D
class_name Building

@export var hp = 1
@export var inhabitable = 1
@export var people : int = 1
@export var destroyed : bool = false
var destroySprite : Texture2D

func destroy():
	texture = destroySprite
	destroyed = true
func damage(power):
	hp -= power
	if(hp <= 0): destroy()
