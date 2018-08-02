extends MeshInstance

export var height_variance = 2

var surface = SurfaceTool.new()

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

# func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	# pass
	
func draw(polygon, centre):
	var mesh = Mesh.new()
	var height = randf() * height_variance
	
	var mat = SpatialMaterial.new()
	# mat.flags_unshaded = true;
	mat.albedo_color = Color(randf(), randf(), randf())
	# mat.albedo_texture = load("res://icon.png");
  
	drawHorizontalPolygon(polygon, centre, height, mat, mesh)
	drawHorizontalPolygon(polygon, centre, 0, mat, mesh)
	
	for i in range (polygon.size()):
		var v = polygon[i]
		var v2 = polygon[(i + 1) % polygon.size()]
		
		drawVerticalSide (v, v2, 0, height, mat, mesh)
  
	self.mesh = mesh

func drawVerticalSide (v1, v2, h0, h1, material, mesh):
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface.set_material(material)
		
	surface.add_uv(Vector2(0, 0))
	surface.add_vertex(Vector3(v1.x, h0, v1.y))
		
	surface.add_uv(Vector2(0, 1))
	surface.add_vertex(Vector3(v1.x, h1, v1.y))
		
	surface.add_uv(Vector2(1, 1))
	surface.add_vertex(Vector3(v2.x, h1, v2.y))
	
	surface.add_uv(Vector2(0, 0))
	surface.add_vertex(Vector3(v1.x, h0, v1.y))
		
	surface.add_uv(Vector2(1, 1))
	surface.add_vertex(Vector3(v2.x, h1, v2.y))
		
	surface.add_uv(Vector2(1, 0))
	surface.add_vertex(Vector3(v2.x, h0, v2.y))
  
	surface.generate_normals()
	surface.index()
  
	surface.commit(mesh)

func drawHorizontalPolygon (polygon, centre, height, material, mesh):
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface.set_material(material)
		
	for i in range (polygon.size()):
		var v = polygon[i]
		var v2 = polygon[(i + 1) % polygon.size()]
		
		surface.add_uv(centre)
		surface.add_vertex(Vector3(centre.x, height, centre.y))
		
		surface.add_uv(v2)
		surface.add_vertex(Vector3(v2.x, height, v2.y))
		
		surface.add_uv(v)
		surface.add_vertex(Vector3(v.x, height, v.y))
  
	surface.generate_normals()
	surface.index()
  
	surface.commit(mesh)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
