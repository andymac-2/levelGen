extends Panel

func _ready ():
	get_node("Button").connect("pressed", self, "_on_Btn_pressed")
	
	
func _on_Btn_pressed ():
	get_node("Label").text = "Pressed!"
