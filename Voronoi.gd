extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var children = []
const cell = preload("voronoiCell.tscn")

func _ready():
	for i in range (100):
		var temp = cell.instance()
		temp.create()
		add_child(temp)
	
	var children = get_children()
	
	for i in range (children.size()):
		for j in range (i, children.size()):
			if i == j:
				continue
			children[i].clip(children[j])
			children[j].clip(children[i])

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass