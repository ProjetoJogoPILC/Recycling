extends KinematicBody2D


onready var pre_select_icon = get_node("PreSelect")

onready var metalDisplay   = get_node("Control/HBoxContainer/VBoxContainer2/metalQtd"  )
onready var plasticDisplay = get_node("Control/HBoxContainer/VBoxContainer2/plasticQtd")
onready var glassDisplay   = get_node("Control/HBoxContainer/VBoxContainer2/glassQtd"  )
onready var eletricDisplay = get_node("Control/HBoxContainer/VBoxContainer2/eletricQtd")

var metal_stored = 0 
var plastic_stored = 0 
var glass_stored = 0 
var eletric_stored = 0

func _ready():
    de_select()
    pre_select_icon = get_node("PreSelect")

    metalDisplay    = get_node("Control/HBoxContainer/VBoxContainer2/metalQtd"  )
    plasticDisplay  = get_node("Control/HBoxContainer/VBoxContainer2/plasticQtd")
    glassDisplay    = get_node("Control/HBoxContainer/VBoxContainer2/glassQtd"  )
    eletricDisplay  = get_node("Control/HBoxContainer/VBoxContainer2/eletricQtd")
    _update_display()

func _process(_delta):
    pass

func pre_select():
    pre_select_icon.show()


func de_select():
    pre_select_icon.hide()


func _on_InteractionArea_area_entered(area):
    if area.is_in_group("pickable"):
        var trash = area.get_owner()
        var trash_type = trash.get_type()
        if trash_type == 0:
            metal_stored += 1
        if trash_type == 1:
            plastic_stored += 1
        if trash_type == 2:
            glass_stored += 1
        if trash_type == 3:
            eletric_stored += 1
        trash.queue_free()
        _update_display()

func _update_display():
    metalDisplay  .set_text(str(metal_stored  ))
    plasticDisplay.set_text(str(plastic_stored))
    glassDisplay  .set_text(str(glass_stored  ))
    eletricDisplay.set_text(str(eletric_stored))
    pass

func _on_InteractionArea_area_exited(area):
    pass # Replace with function body.
