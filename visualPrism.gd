extends MeshInstance

export var height_variance = 0.5

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

# func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	# pass
	
func draw(polygon, centre):
	var height = randf() * height_variance
	
	var surface = SurfaceTool.new()
	var mesh = Mesh.new()
	
	var mat = SpatialMaterial.new()
	mat.flags_unshaded = true;
	mat.albedo_color = Color(randf(), randf(), randf())
	# mat.albedo_texture = load("res://icon.png");
  
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface.set_material(mat)
	
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
  
	self.mesh = mesh

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
