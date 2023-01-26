extends Sprite


export(int, "metal", "plastic", "glass", "eletric") var trash_type

onready var pre_select_icon = get_node("PreSelect")


func _ready():
    pre_select_icon = get_node("PreSelect")
    set_type(trash_type)
    de_select()


func set_type(new_type):
    trash_type = new_type
    frame = new_type


func get_type():
    return trash_type


func pre_select():
    pre_select_icon.show()


func de_select():
    pre_select_icon.hide()
