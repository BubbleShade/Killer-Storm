extends Sprite2D
class_name Building

@export var hp = 1
@export var inhabitable : bool = true
@export var people : int = 1
var destroyed : bool = false
@export var destructionValue : int = 1
@export var buildingType : String = "house"

@onready var levelHandler : LevelHandler = LevelInfo.get_level_handler()

var destroySprite : Texture2D
var spriteTable = {}

func _ready() -> void:
	levelHandler.maxDestruction += destructionValue + people

func destroy():
	if(destroyed): return
	if(destroySprite): texture = destroySprite
	elif(str("Fire0") in spriteTable): texture = spriteTable["Fire0"]
	destroyed = true
	levelHandler.destruction += destructionValue
	$Area2D.monitoring = false
func damage(power):
	hp -= power
	if(hp <= 0): 
		destroy()
		return
	if(str("Fire", hp) in spriteTable): texture = spriteTable[str("Fire", hp)]
