extends Interactable
@export var tileMap : TileMapLayer
@export var RadiusX : float
@export var RadiusY : float



# https://www.redblobgames.com/grids/circle-drawing/
func inside_circle(center : Vector2, tile : Vector2, radiusX : float, radiusY : float) -> bool:
	var yRadiusModifier = radiusX / radiusY
	var dx = center.x - tile.x
	var dy = (center.y - tile.y) * yRadiusModifier;
	var distance = dx*dx + dy*dy;
	
	return distance <= radiusX * radiusX;
func getCircle(center : Vector2i, radiusX : float, radiusY : float):
	var top    =  floor(center.y - radiusY) -1
	var bottom = ceil(center.y + radiusY) + 1
	var left   =  floor(center.x - radiusX) -1
	var right  = ceil(center.x + radiusX) + 1
	for x in range(left, right):
		for y in range(top, bottom):
			if inside_circle(center, Vector2(x, y), radiusX, radiusY): 
				tileMap.set_cell(Vector2i(x, y), 0, Vector2i(0,1), 0)
				pass
				# draw tile (x, y)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	if(LevelInfo.started):
		getCircle(position/8, RadiusX, RadiusY)
