extends Node

# the outer bounding box of every polygon. creating a cell with it's centre
# outside of these bounds is not defined.
const top = 0
const left = 0
var bottom = 400
var right = 700
var boundary = []

enum {TOP, LEFT, BOTTOM, RIGHT}
# sorted clockwise
# var polygon should also be sorted clockwise
# the starting poing should be the edge that finishes with the first
# vertex of polygon
var adjacentCells = [TOP, LEFT, BOTTOM, RIGHT]
var centre = Vector2(200, 200)

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
func init(point, b, r) :
	centre = point
	bottom = b
	right = r
	boundary = [
		Vector2 (left, top),
		Vector2 (left, bottom),
		Vector2 (right, bottom),
		Vector2 (right, top)
	]
	
func cement():
	var poly = get_node("visualPrism")
	poly.draw(boundary, centre)
	
# func _process ():
	
# clip a voronoi polygon with an uninitialised polygon.
# it is assumed that the voronoi cell to be clipped is already valid 
# in it's diagram
func clip (cell):
	if cell.boundary.size() == 0 :
		return [null, null]
		
	var newPoly = []
	var newAdjacents = []
	var clipped = false
	var previous = cell.boundary[cell.boundary.size() - 1]
	var clipFirst
	var clipSecond
	
	for i in range (cell.boundary.size()):
		var current = cell.boundary[i]
		# current vertex not clipped
		if comparePointToBisector (cell.centre, centre, current):
			# previous vertex clipped
			if !comparePointToBisector (cell.centre, centre, previous):
				newAdjacents.push_back(self)
				newPoly.push_back(
					intersection (cell, cell.adjacentCells[i]))
				clipFirst = cell.adjacentCells[i]
			
			newAdjacents.push_back(cell.adjacentCells[i])
			newPoly.push_back(current)
			
		# current vertex clipped and previous not clipped
		elif comparePointToBisector(cell.centre, centre, previous):
			newAdjacents.push_back(cell.adjacentCells[i])
			newPoly.push_back(
				intersection (cell, cell.adjacentCells[i]))
			clipSecond = cell.adjacentCells[i]
		
		previous = current
		
	cell.boundary = newPoly
	cell.adjacentCells = newAdjacents
	
	return [clipFirst, clipSecond]

func intersection (cell1, cell2):
	var c2 = deboundaryfy(cell2)
	return circumcentre (centre, cell1.centre, c2)
	
func deboundaryfy (cell):
	match cell:
		TOP: return Vector2(centre.x, top * 2 - centre.y)
		BOTTOM: return Vector2(centre.x, bottom * 2 - centre.y)
		LEFT: return Vector2(left * 2 - centre.x, centre.y)
		RIGHT: return Vector2(right * 2 - centre.x, centre.y)
		_: return cell.centre
	

func circumcentre (p1, p2, p3):
	var cx1 = 2 * (p3.x - p1.x)
	var cx2 = 2 * (p3.x - p2.x)
	var cy1 = 2 * (p3.y - p1.y)
	var cy2 = 2 * (p3.y - p2.y)
	var determinant = cx1 * cy2 - cx2 * cy1
	
	if determinant == 0:
		return null
	
	var c1 = p3.x * p3.x - p1.x * p1.x + p3.y * p3.y - p1.y * p1.y
	var c2 = p3.x * p3.x - p2.x * p2.x + p3.y * p3.y - p2.y * p2.y
	var x = (cy2 * c1 - cy1 * c2) / determinant
	var y = (cx1 * c2 - cx2 * c1) / determinant
	
	return Vector2(x, y)


# returns true if point t is closer to a, false if t is closer to b.
func comparePointToBisector (a, b, t):
	var dax = (a.x - t.x) * (a.x - t.x)
	var day = (a.y - t.y) * (a.y - t.y)
	var dbx = (b.x - t.x) * (b.x - t.x)
	var dby = (b.y - t.y) * (b.y - t.y)
	
	return dax + day < dbx + dby
	