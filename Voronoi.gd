extends Node

# top and left are both set to 0
export var bottom = 20
export var right = 20

export var r = 2

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var children = []
const cell = preload("voronoiCell.tscn")

func _ready():
	var points = bridsons(r, r*2, 10)
	
	for p in points:
		var temp = cell.instance()
		temp.init(p, bottom, right)
		add_child(temp)
	
	var children = get_children()
	
	for i in range (children.size()):
		for j in range (i, children.size()):
			if i == j:
				continue
			children[i].clip(children[j])
			children[j].clip(children[i])
			
	for c in children:
		c.cement()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func bridsons(r, R, k):
	var index = 0
		
	var gridSize = r / sqrt(2)
	var gridWidth = ceil(right/gridSize)
	var gridHeight = ceil(bottom/gridSize)
		
	var grid = []
	for x in range(gridWidth):
    	grid.push_back([])
    	for y in range(gridHeight):
        	grid[x].push_back(null)
		
	var points = [
		Vector2(randf() * right, randf() * bottom)
	]
	grid[floor(points[0].x / gridSize)][floor(points[0].y / gridSize)] = points[0]
		
	var xCoef = R * R - (r * r)
	
	while index < points.size():
		var point = points[index]
		
		var success = false
		for i in range (k):
			var mag = sqrt(randf() * xCoef + (r * r))
			var arg = randf() * TAU
			
			var px = point.x + cos(arg) * mag
			var py = point.y + sin(arg) * mag

			if px >= right || px < 0 || py >= bottom || py < 0 :
				continue
				
			var gx = floor(px / gridSize);
			var gy = floor(py / gridSize);
			
			var pointTooClose = false
			for x in [-2, -1, 0, 1, 2]:
				for y in [-2, -1, 0, 1, 2]:
					if (x + gx < 0 || x + gx >= gridWidth ||
						y + gy < 0 || y + gy >= gridHeight) :
							continue
					
					var testp = grid[x + gx][y + gy]
					
					if !testp:
						continue
						
					var dx = testp.x - px
					var dy = testp.y - py
					
					if dx * dx + dy * dy < r * r:
						pointTooClose = true
						break
						
			if pointTooClose == false:
				var p2 = Vector2 (px, py)
				grid[gx][gy] = p2
				points.push_back(p2)
				success = true
				break
		
		if success == false:
			index += 1

	return points