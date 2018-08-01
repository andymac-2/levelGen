extends MeshInstance

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var mat = SpatialMaterial.new();
	mat.flags_unshaded = true;
	mat.albedo_texture = load("res://icon.png");
	var size = 2;
	var surfaceTool = SurfaceTool.new();
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surfaceTool.set_material(mat)
	surfaceTool.add_uv(Vector2(0, 0));
	surfaceTool.add_vertex(Vector3(-size, -size,  0))
	surfaceTool.add_uv(Vector2(1, 1));
	surfaceTool.add_vertex(Vector3( size,  size,  0))
	surfaceTool.add_uv(Vector2(1, 0));
	surfaceTool.add_vertex(Vector3( size, -size,  0))
	surfaceTool.add_uv(Vector2(0, 0));
	surfaceTool.add_vertex(Vector3(-size, -size,  0))
	surfaceTool.add_uv(Vector2(0, 1));
	surfaceTool.add_vertex(Vector3(-size,  size,  0))
	surfaceTool.add_uv(Vector2(1, 1));
	surfaceTool.add_vertex(Vector3( size,  size,  0))
	surfaceTool.generate_normals()
	
	var new_mesh = surfaceTool.commit()
	self.mesh = new_mesh;
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
